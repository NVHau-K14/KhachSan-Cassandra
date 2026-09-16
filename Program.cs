using Cassandra;
using web_hotel_cassandra.Models;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddRazorPages();

// Cấu hình Cassandra Client
var cluster = Cluster.Builder()
                     .AddContactPoint("127.0.0.1")
                     .WithPort(9042)
                     .Build();

var session = cluster.Connect("quanlykhachsan");

// Đăng ký UDT
session.UserDefinedTypes.Define(
    UdtMap.For<AddressUDT>("address")
          .Map(a => a.street, "street")
          .Map(a => a.city, "city")
          .Map(a => a.state_or_province, "state_or_province")
          .Map(a => a.postal_code, "postal_code")
          .Map(a => a.country, "country")
);

// Sửa lại kiểu Cassandra.ISession rõ ràng
builder.Services.AddSingleton<Cassandra.ISession>(session);

var app = builder.Build();

if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error");
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();
app.UseRouting();
app.UseAuthorization();
app.MapRazorPages();

app.Run();