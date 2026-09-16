namespace web_hotel_cassandra.Models
{
    public class AddressUDT
    {
        public string? street { get; set; }
        public string? city { get; set; }
        public string? state_or_province { get; set; }
        public string? postal_code { get; set; }
        public string? country { get; set; }
    }

    public class HotelViewModel
    {
        public string Id { get; set; } = string.Empty;
        public string Name { get; set; } = string.Empty;
        public string Phone { get; set; } = string.Empty;
        public string FullAddress { get; set; } = string.Empty;
        public string? ImageUrl { get; set; }
        public decimal MinPrice { get; set; }
        public string? PoiName { get; set; }
    }

    public class PoiViewModel
    {
        public string Name { get; set; } = string.Empty;
        public string? ImageUrl { get; set; }
        public string? Description { get; set; }
    }

    public class RoomViewModel
    {
        public int RoomNumber { get; set; }
        public int Capacity { get; set; }
        public decimal Price { get; set; }
        public bool IsAvailable { get; set; }
    }
}