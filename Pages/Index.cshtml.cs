using Cassandra;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Globalization;
using System.Text;
using System.Text.RegularExpressions;
using web_hotel_cassandra.Models;

namespace web_hotel_cassandra.Pages
{
    public class IndexModel : PageModel
    {
        private readonly Cassandra.ISession _session;

        public IndexModel(Cassandra.ISession session)
        {
            _session = session;
        }

        public List<HotelViewModel> Hotels { get; set; } = new();
        public List<PoiViewModel> Pois { get; set; } = new();

        [BindProperty(SupportsGet = true)]
        public string? SelectedPoi { get; set; }

        [BindProperty(SupportsGet = true)]
        public string? SearchKeyword { get; set; }

        public void OnGet()
        {
            // 1. Tải danh sách các POI kèm ảnh
            var poiRows = _session.Execute("SELECT name, image_url, description FROM points_of_interest;");
            foreach (var r in poiRows)
            {
                Pois.Add(new PoiViewModel
                {
                    Name = r.GetValue<string>("name"),
                    ImageUrl = r.GetValue<string>("image_url"),
                    Description = r.GetValue<string>("description")
                });
            }

            // 2. Tải khách sạn theo POI nếu người dùng nhấp chọn card địa điểm (Q1)
            RowSet hotelRows;
            if (!string.IsNullOrEmpty(SelectedPoi))
            {
                var stmt = _session.Prepare("SELECT hotel_id, name, phone, address, image_url FROM hotels_by_poi WHERE poi_name = ?;");
                hotelRows = _session.Execute(stmt.Bind(SelectedPoi));
            }
            else
            {
                hotelRows = _session.Execute("SELECT id, name, phone, address, image_url FROM hotels;");
            }

            var prepRoomStmt = _session.Prepare("SELECT price FROM rooms_by_hotel WHERE hotel_id = ?;");
            var allHotels = new List<HotelViewModel>();

            foreach (var row in hotelRows)
            {
                var id = row.GetColumn("id") != null ? row.GetValue<string>("id") : row.GetValue<string>("hotel_id");
                var addr = row.GetValue<AddressUDT>("address");
                var fullAddr = addr != null ? $"{addr.street}, {addr.city}" : "Không có địa chỉ";

                decimal minPrice = 0;
                var roomRows = _session.Execute(prepRoomStmt.Bind(id));
                var prices = roomRows.Select(r => r.GetValue<decimal>("price")).ToList();
                if (prices.Any())
                {
                    minPrice = prices.Min();
                }

                allHotels.Add(new HotelViewModel
                {
                    Id = id,
                    Name = row.GetValue<string>("name"),
                    Phone = row.GetValue<string>("phone"),
                    FullAddress = fullAddr,
                    ImageUrl = row.GetValue<string>("image_url"),
                    MinPrice = minPrice,
                    PoiName = SelectedPoi
                });
            }

            // 3. Tìm kiếm linh hoạt không phân biệt hoa thường và không dấu
            if (!string.IsNullOrWhiteSpace(SearchKeyword))
            {
                var normalizedKeyword = RemoveDiacritics(SearchKeyword.Trim().ToLower());
                Hotels = allHotels.Where(h =>
                    RemoveDiacritics(h.Name.ToLower()).Contains(normalizedKeyword) ||
                    RemoveDiacritics(h.FullAddress.ToLower()).Contains(normalizedKeyword)
                ).ToList();
            }
            else
            {
                Hotels = allHotels;
            }
        }

        // Hàm loại bỏ dấu tiếng Việt chuẩn Unicode
        private static string RemoveDiacritics(string text)
        {
            if (string.IsNullOrWhiteSpace(text))
                return text;

            var normalizedString = text.Normalize(NormalizationForm.FormD);
            var stringBuilder = new StringBuilder();

            foreach (var c in normalizedString)
            {
                var unicodeCategory = CharUnicodeInfo.GetUnicodeCategory(c);
                if (unicodeCategory != UnicodeCategory.NonSpacingMark)
                {
                    stringBuilder.Append(c);
                }
            }

            return stringBuilder.ToString().Normalize(NormalizationForm.FormC).Replace('đ', 'd').Replace('Đ', 'D');
        }
    }
}