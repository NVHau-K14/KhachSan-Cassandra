using Cassandra;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using web_hotel_cassandra.Models;

namespace web_hotel_cassandra.Pages
{
    public class HotelDetailsModel : PageModel
    {
        private readonly Cassandra.ISession _session;

        public HotelDetailsModel(Cassandra.ISession session)
        {
            _session = session;
        }

        public HotelViewModel Hotel { get; set; } = new();
        public List<RoomViewModel> Rooms { get; set; } = new();

        [BindProperty(SupportsGet = true)]
        public string CheckDate { get; set; } = "2026-10-01";

        public IActionResult OnGet(string? id)
        {
            if (string.IsNullOrEmpty(id))
            {
                return RedirectToPage("/Index");
            }

            // 1. Lấy thông tin khách sạn từ hotels (Q2)
            var prep = _session.Prepare("SELECT id, name, phone, address, image_url FROM hotels WHERE id = ?;");
            var row = _session.Execute(prep.Bind(id)).FirstOrDefault();

            if (row == null)
            {
                return NotFound();
            }

            var addr = row.GetValue<AddressUDT>("address");
            var fullAddr = addr != null ? $"{addr.street}, {addr.city}, {addr.state_or_province}, {addr.country}" : "Không có địa chỉ";

            // 2. Tìm điểm tham quan gần nhất từ hotels_by_poi
            string poiName = "Khu vực trung tâm";
            var poiRows = _session.Execute("SELECT poi_name, hotel_id FROM hotels_by_poi;");
            var matchedPoi = poiRows.FirstOrDefault(r => r.GetValue<string>("hotel_id") == id);
            if (matchedPoi != null)
            {
                poiName = matchedPoi.GetValue<string>("poi_name");
            }

            Hotel = new HotelViewModel
            {
                Id = row.GetValue<string>("id"),
                Name = row.GetValue<string>("name"),
                Phone = row.GetValue<string>("phone"),
                FullAddress = fullAddr,
                ImageUrl = row.GetValue<string>("image_url"),
                PoiName = poiName
            };

            // 3. Tải danh sách phòng từ rooms_by_hotel (Q3)
            var prepRooms = _session.Prepare("SELECT room_number, capacity, price FROM rooms_by_hotel WHERE hotel_id = ?;");
            var roomRows = _session.Execute(prepRooms.Bind(id));

            // 4. Lấy trạng thái phòng trống theo ngày (Q4)
            var prepAvail = _session.Prepare("SELECT room_number, is_available FROM available_rooms_by_hotel_date WHERE hotel_id = ? AND date = ?;");
            var availRows = _session.Execute(prepAvail.Bind(id, CheckDate))
                                    .ToDictionary(r => r.GetValue<int>("room_number"), r => r.GetValue<bool>("is_available"));

            foreach (var r in roomRows)
            {
                var rNum = r.GetValue<int>("room_number");
                bool isAvailable = availRows.ContainsKey(rNum) ? availRows[rNum] : true;

                Rooms.Add(new RoomViewModel
                {
                    RoomNumber = rNum,
                    Capacity = r.GetValue<int>("capacity"),
                    Price = r.GetValue<decimal>("price"),
                    IsAvailable = isAvailable
                });
            }

            return Page();
        }
    }
}