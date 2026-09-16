-- ============================================================
-- QUAN LY KHACH SAN - DU LIEU VIET NAM
-- 5 dia diem noi tieng, moi dia diem 5 khach san
-- Gia phong, so phong, khach va dat phong: DU LIEU MAU
-- ============================================================

CREATE KEYSPACE IF NOT EXISTS QuanLyKhachSan
WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};

USE QuanLyKhachSan;

-- Kieu du lieu dia chi
CREATE TYPE IF NOT EXISTS address (
    street text,
    city text,
    state_or_province text,
    postal_code text,
    country text
);

-- Bang 1: Luu thong tin khach san
CREATE TABLE IF NOT EXISTS hotels (
    id text,
    name text,
    phone text,
    address frozen<address>,
    image_url text,
    PRIMARY KEY (id)
);

-- Bang 2: Tra cuu khach san theo diem quan tam (POI)
CREATE TABLE IF NOT EXISTS hotels_by_poi (
    poi_name text,
    hotel_id text,
    name text,
    phone text,
    address frozen<address>,
    image_url text,
    PRIMARY KEY (poi_name, hotel_id)
);

-- Bang 3: Tra cuu danh sach phong theo khach san
CREATE TABLE IF NOT EXISTS rooms_by_hotel (
    hotel_id text,
    room_number int,
    capacity int,
    price decimal,
    PRIMARY KEY (hotel_id, room_number)
);

-- Bang 4: Tra cuu phong trong theo khach san va ngay
CREATE TABLE IF NOT EXISTS available_rooms_by_hotel_date (
    hotel_id text,
    date text,
    room_number int,
    is_available boolean,
    PRIMARY KEY ((hotel_id, date), room_number)
);

-- Bang 5: Luu thong tin chi tiet khach hang
CREATE TABLE IF NOT EXISTS guests (
    guest_id text,
    first_name text,
    last_name text,
    title text,
    email text,
    phone_numbers set<text>,
    addresses map<text, frozen<address>>,
    PRIMARY KEY (guest_id)
);

-- Bang 6: Tra cuu dat phong theo khach san va ngay bat dau
CREATE TABLE IF NOT EXISTS reservations_by_hotel_date (
    hotel_id text,
    start_date text,
    room_number int,
    end_date text,
    confirm_number text,
    guest_id text,
    PRIMARY KEY ((hotel_id, start_date), room_number)
);

-- Bang 7: Tra cuu dat phong theo ma xac nhan
CREATE TABLE IF NOT EXISTS reservations_by_confirmation (
    confirm_number text,
    hotel_id text,
    room_number int,
    start_date text,
    end_date text,
    guest_id text,
    PRIMARY KEY (confirm_number, hotel_id)
);

-- Bang 8: Tra cuu dat phong theo ho khach hang
CREATE TABLE IF NOT EXISTS reservations_by_guest (
    guest_last_name text,
    hotel_id text,
    guest_id text,
    room_number int,
    start_date text,
    end_date text,
    confirm_number text,
    PRIMARY KEY (guest_last_name, hotel_id, guest_id)
);

-- ============================================================
-- 1. DU LIEU BANG HOTELS: 25 KHACH SAN (CO ANH)
-- ============================================================
INSERT INTO hotels (id, name, phone, address, image_url) VALUES ('H01', 'New World Saigon Hotel', '02838228888', {street: '76 Le Lai, District 1', city: 'Ho Chi Minh City', state_or_province: 'Ho Chi Minh City', postal_code: '700000', country: 'VN'}, '/images/KhachSan1.webp');
INSERT INTO hotels (id, name, phone, address, image_url) VALUES ('H02', 'Fusion Suites Saigon', '02838219300', {street: '3-5 Suong Nguyet Anh, District 1', city: 'Ho Chi Minh City', state_or_province: 'Ho Chi Minh City', postal_code: '700000', country: 'VN'}, '/images/KhachSan2.webp');
INSERT INTO hotels (id, name, phone, address, image_url) VALUES ('H03', 'Rex Hotel Saigon', '02838292185', {street: '141 Nguyen Hue, District 1', city: 'Ho Chi Minh City', state_or_province: 'Ho Chi Minh City', postal_code: '700000', country: 'VN'}, '/images/KhachSan3.webp');
INSERT INTO hotels (id, name, phone, address, image_url) VALUES ('H04', 'Liberty Central Saigon Citypoint', '02838225799', {street: '59-61 Pasteur, District 1', city: 'Ho Chi Minh City', state_or_province: 'Ho Chi Minh City', postal_code: '700000', country: 'VN'}, '/images/KhachSan4.webp');
INSERT INTO hotels (id, name, phone, address, image_url) VALUES ('H05', 'Grand Hotel Saigon', '02839155555', {street: '8 Dong Khoi, District 1', city: 'Ho Chi Minh City', state_or_province: 'Ho Chi Minh City', postal_code: '700000', country: 'VN'}, '/images/KhachSan5.webp');
INSERT INTO hotels (id, name, phone, address, image_url) VALUES ('H06', 'Apricot Hotel', '02462827777', {street: '136 Hang Trong, Hoan Kiem', city: 'Hanoi', state_or_province: 'Hanoi', postal_code: '100000', country: 'VN'}, '/images/KhachSan6.webp');
INSERT INTO hotels (id, name, phone, address, image_url) VALUES ('H07', 'The Oriental Jade Hotel', '02439366666', {street: '92-94 Hang Trong, Hoan Kiem', city: 'Hanoi', state_or_province: 'Hanoi', postal_code: '100000', country: 'VN'}, '/images/KhachSan7.webp');
INSERT INTO hotels (id, name, phone, address, image_url) VALUES ('H08', 'Hanoi Solis Hotel', '02438288666', {street: '5 Hang Dau, Hoan Kiem', city: 'Hanoi', state_or_province: 'Hanoi', postal_code: '100000', country: 'VN'}, '/images/KhachSan8.webp');
INSERT INTO hotels (id, name, phone, address, image_url) VALUES ('H09', 'Minerva Church Hotel', '02439338888', {street: '9-11 Ly Thai To, Hoan Kiem', city: 'Hanoi', state_or_province: 'Hanoi', postal_code: '100000', country: 'VN'}, '/images/KhachSan9.webp');
INSERT INTO hotels (id, name, phone, address, image_url) VALUES ('H10', 'La Passion Hanoi Hotel & Spa', '02439331111', {street: '26 Cau Go, Hoan Kiem', city: 'Hanoi', state_or_province: 'Hanoi', postal_code: '100000', country: 'VN'}, '/images/KhachSan10.webp');
INSERT INTO hotels (id, name, phone, address, image_url) VALUES ('H11', 'Stella Maris Beach Danang', '02363955555', {street: '3 Vo Van Kiet, Son Tra', city: 'Da Nang', state_or_province: 'Da Nang', postal_code: '550000', country: 'VN'}, '/images/KhachSan11.webp');
INSERT INTO hotels (id, name, phone, address, image_url) VALUES ('H12', 'Sala Danang Beach Hotel', '02363917777', {street: '36-38 Lam Hoanh, Son Tra', city: 'Da Nang', state_or_province: 'Da Nang', postal_code: '550000', country: 'VN'}, '/images/KhachSan12.webp');
INSERT INTO hotels (id, name, phone, address, image_url) VALUES ('H13', 'De Lamour Hotel Da Nang', '02363955566', {street: '46-48 Tran Bach Dang, Ngu Hanh Son', city: 'Da Nang', state_or_province: 'Da Nang', postal_code: '550000', country: 'VN'}, '/images/KhachSan13.webp');
INSERT INTO hotels (id, name, phone, address, image_url) VALUES ('H14', 'A La Carte Danang Beach', '02363955588', {street: '200 Vo Nguyen Giap, Son Tra', city: 'Da Nang', state_or_province: 'Da Nang', postal_code: '550000', country: 'VN'}, '/images/KhachSan14.webp');
INSERT INTO hotels (id, name, phone, address, image_url) VALUES ('H15', 'Hilton Garden Inn Da Nang', '02363877888', {street: '96 Vo Nguyen Giap, Son Tra', city: 'Da Nang', state_or_province: 'Da Nang', postal_code: '550000', country: 'VN'}, '/images/KhachSan15.webp');
INSERT INTO hotels (id, name, phone, address, image_url) VALUES ('H16', 'InterContinental Nha Trang', '02563988888', {street: '32-34 Tran Phu', city: 'Nha Trang', state_or_province: 'Nha Trang', postal_code: '650000', country: 'VN'}, '/images/KhachSan16.webp');
INSERT INTO hotels (id, name, phone, address, image_url) VALUES ('H17', 'Sheraton Nha Trang Hotel & Spa', '02563888888', {street: '26-28 Tran Phu', city: 'Nha Trang', state_or_province: 'Nha Trang', postal_code: '650000', country: 'VN'}, '/images/KhachSan17.webp');
INSERT INTO hotels (id, name, phone, address, image_url) VALUES ('H18', 'Vinpearl Beachfront Nha Trang', '02583599999', {street: '78-80 Tran Phu', city: 'Nha Trang', state_or_province: 'Nha Trang', postal_code: '650000', country: 'VN'}, '/images/KhachSan18.webp');
INSERT INTO hotels (id, name, phone, address, image_url) VALUES ('H19', 'Havana Nha Trang Hotel', '02583888888', {street: '38 Tran Phu', city: 'Nha Trang', state_or_province: 'Nha Trang', postal_code: '650000', country: 'VN'}, '/images/KhachSan19.webp');
INSERT INTO hotels (id, name, phone, address, image_url) VALUES ('H20', 'Novotel Nha Trang', '02586255555', {street: '50 Tran Phu', city: 'Nha Trang', state_or_province: 'Nha Trang', postal_code: '650000', country: 'VN'}, '/images/KhachSan20.webp');
INSERT INTO hotels (id, name, phone, address, image_url) VALUES ('H21', 'Allegro Hoi An - A Little Luxury Hotel & Spa', '02353911111', {street: '86 Tran Hung Dao, Cam Pho', city: 'Hoi An', state_or_province: 'Hoi An', postal_code: '560000', country: 'VN'}, '/images/KhachSan21.webp');
INSERT INTO hotels (id, name, phone, address, image_url) VALUES ('H22', 'La Charm Hoi An Hotel', '02353922222', {street: '64 Nguyen Thai Hoc, Minh An', city: 'Hoi An', state_or_province: 'Hoi An', postal_code: '560000', country: 'VN'}, '/images/KhachSan22.webp');
INSERT INTO hotels (id, name, phone, address, image_url) VALUES ('H23', 'Hoi An Historic Hotel', '02353936666', {street: '10 Tran Hung Dao, Son Phong', city: 'Hoi An', state_or_province: 'Hoi An', postal_code: '560000', country: 'VN'}, '/images/KhachSan23.webp');
INSERT INTO hotels (id, name, phone, address, image_url) VALUES ('H24', 'Laluna Hoi An Riverside Hotel & Spa', '02353937777', {street: '12 Nguyen Du, Cam Pho', city: 'Hoi An', state_or_province: 'Hoi An', postal_code: '560000', country: 'VN'}, '/images/KhachSan24.webp');
INSERT INTO hotels (id, name, phone, address, image_url) VALUES ('H25', 'Golden River Hotel Hoi An', '02353938888', {street: '04 Nguyen Phuc Nguyen, Cam Pho', city: 'Hoi An', state_or_province: 'Hoi An', postal_code: '560000', country: 'VN'}, '/images/KhachSan25.webp');

-- ============================================================
-- 2. DU LIEU BANG HOTELS_BY_POI: 5 POI x 5 KHACH SAN (CO ANH)
-- ============================================================
INSERT INTO hotels_by_poi (poi_name, hotel_id, name, phone, address, image_url) VALUES ('Ben Thanh Market', 'H01', 'New World Saigon Hotel', '02838228888', {street: '76 Le Lai, District 1', city: 'Ho Chi Minh City', state_or_province: 'Ho Chi Minh City', postal_code: '700000', country: 'VN'}, '/images/KhachSan1.webp');
INSERT INTO hotels_by_poi (poi_name, hotel_id, name, phone, address, image_url) VALUES ('Ben Thanh Market', 'H02', 'Fusion Suites Saigon', '02838219300', {street: '3-5 Suong Nguyet Anh, District 1', city: 'Ho Chi Minh City', state_or_province: 'Ho Chi Minh City', postal_code: '700000', country: 'VN'}, '/images/KhachSan2.webp');
INSERT INTO hotels_by_poi (poi_name, hotel_id, name, phone, address, image_url) VALUES ('Ben Thanh Market', 'H03', 'Rex Hotel Saigon', '02838292185', {street: '141 Nguyen Hue, District 1', city: 'Ho Chi Minh City', state_or_province: 'Ho Chi Minh City', postal_code: '700000', country: 'VN'}, '/images/KhachSan3.webp');
INSERT INTO hotels_by_poi (poi_name, hotel_id, name, phone, address, image_url) VALUES ('Ben Thanh Market', 'H04', 'Liberty Central Saigon Citypoint', '02838225799', {street: '59-61 Pasteur, District 1', city: 'Ho Chi Minh City', state_or_province: 'Ho Chi Minh City', postal_code: '700000', country: 'VN'}, '/images/KhachSan4.webp');
INSERT INTO hotels_by_poi (poi_name, hotel_id, name, phone, address, image_url) VALUES ('Ben Thanh Market', 'H05', 'Grand Hotel Saigon', '02839155555', {street: '8 Dong Khoi, District 1', city: 'Ho Chi Minh City', state_or_province: 'Ho Chi Minh City', postal_code: '700000', country: 'VN'}, '/images/KhachSan5.webp');
INSERT INTO hotels_by_poi (poi_name, hotel_id, name, phone, address, image_url) VALUES ('Hoan Kiem Lake', 'H06', 'Apricot Hotel', '02462827777', {street: '136 Hang Trong, Hoan Kiem', city: 'Hanoi', state_or_province: 'Hanoi', postal_code: '100000', country: 'VN'}, '/images/KhachSan6.webp');
INSERT INTO hotels_by_poi (poi_name, hotel_id, name, phone, address, image_url) VALUES ('Hoan Kiem Lake', 'H07', 'The Oriental Jade Hotel', '02439366666', {street: '92-94 Hang Trong, Hoan Kiem', city: 'Hanoi', state_or_province: 'Hanoi', postal_code: '100000', country: 'VN'}, '/images/KhachSan7.webp');
INSERT INTO hotels_by_poi (poi_name, hotel_id, name, phone, address, image_url) VALUES ('Hoan Kiem Lake', 'H08', 'Hanoi Solis Hotel', '02438288666', {street: '5 Hang Dau, Hoan Kiem', city: 'Hanoi', state_or_province: 'Hanoi', postal_code: '100000', country: 'VN'}, '/images/KhachSan8.webp');
INSERT INTO hotels_by_poi (poi_name, hotel_id, name, phone, address, image_url) VALUES ('Hoan Kiem Lake', 'H09', 'Minerva Church Hotel', '02439338888', {street: '9-11 Ly Thai To, Hoan Kiem', city: 'Hanoi', state_or_province: 'Hanoi', postal_code: '100000', country: 'VN'}, '/images/KhachSan9.webp');
INSERT INTO hotels_by_poi (poi_name, hotel_id, name, phone, address, image_url) VALUES ('Hoan Kiem Lake', 'H10', 'La Passion Hanoi Hotel & Spa', '02439331111', {street: '26 Cau Go, Hoan Kiem', city: 'Hanoi', state_or_province: 'Hanoi', postal_code: '100000', country: 'VN'}, '/images/KhachSan10.webp');
INSERT INTO hotels_by_poi (poi_name, hotel_id, name, phone, address, image_url) VALUES ('My Khe Beach', 'H11', 'Stella Maris Beach Danang', '02363955555', {street: '3 Vo Van Kiet, Son Tra', city: 'Da Nang', state_or_province: 'Da Nang', postal_code: '550000', country: 'VN'}, '/images/KhachSan11.webp');
INSERT INTO hotels_by_poi (poi_name, hotel_id, name, phone, address, image_url) VALUES ('My Khe Beach', 'H12', 'Sala Danang Beach Hotel', '02363917777', {street: '36-38 Lam Hoanh, Son Tra', city: 'Da Nang', state_or_province: 'Da Nang', postal_code: '550000', country: 'VN'}, '/images/KhachSan12.webp');
INSERT INTO hotels_by_poi (poi_name, hotel_id, name, phone, address, image_url) VALUES ('My Khe Beach', 'H13', 'De Lamour Hotel Da Nang', '02363955566', {street: '46-48 Tran Bach Dang, Ngu Hanh Son', city: 'Da Nang', state_or_province: 'Da Nang', postal_code: '550000', country: 'VN'}, '/images/KhachSan13.webp');
INSERT INTO hotels_by_poi (poi_name, hotel_id, name, phone, address, image_url) VALUES ('My Khe Beach', 'H14', 'A La Carte Danang Beach', '02363955588', {street: '200 Vo Nguyen Giap, Son Tra', city: 'Da Nang', state_or_province: 'Da Nang', postal_code: '550000', country: 'VN'}, '/images/KhachSan14.webp');
INSERT INTO hotels_by_poi (poi_name, hotel_id, name, phone, address, image_url) VALUES ('My Khe Beach', 'H15', 'Hilton Garden Inn Da Nang', '02363877888', {street: '96 Vo Nguyen Giap, Son Tra', city: 'Da Nang', state_or_province: 'Da Nang', postal_code: '550000', country: 'VN'}, '/images/KhachSan15.webp');
INSERT INTO hotels_by_poi (poi_name, hotel_id, name, phone, address, image_url) VALUES ('Nha Trang Beach', 'H16', 'InterContinental Nha Trang', '02563988888', {street: '32-34 Tran Phu', city: 'Nha Trang', state_or_province: 'Nha Trang', postal_code: '650000', country: 'VN'}, '/images/KhachSan16.webp');
INSERT INTO hotels_by_poi (poi_name, hotel_id, name, phone, address, image_url) VALUES ('Nha Trang Beach', 'H17', 'Sheraton Nha Trang Hotel & Spa', '02563888888', {street: '26-28 Tran Phu', city: 'Nha Trang', state_or_province: 'Nha Trang', postal_code: '650000', country: 'VN'}, '/images/KhachSan17.webp');
INSERT INTO hotels_by_poi (poi_name, hotel_id, name, phone, address, image_url) VALUES ('Nha Trang Beach', 'H18', 'Vinpearl Beachfront Nha Trang', '02583599999', {street: '78-80 Tran Phu', city: 'Nha Trang', state_or_province: 'Nha Trang', postal_code: '650000', country: 'VN'}, '/images/KhachSan18.webp');
INSERT INTO hotels_by_poi (poi_name, hotel_id, name, phone, address, image_url) VALUES ('Nha Trang Beach', 'H19', 'Havana Nha Trang Hotel', '02583888888', {street: '38 Tran Phu', city: 'Nha Trang', state_or_province: 'Nha Trang', postal_code: '650000', country: 'VN'}, '/images/KhachSan19.webp');
INSERT INTO hotels_by_poi (poi_name, hotel_id, name, phone, address, image_url) VALUES ('Nha Trang Beach', 'H20', 'Novotel Nha Trang', '02586255555', {street: '50 Tran Phu', city: 'Nha Trang', state_or_province: 'Nha Trang', postal_code: '650000', country: 'VN'}, '/images/KhachSan20.webp');
INSERT INTO hotels_by_poi (poi_name, hotel_id, name, phone, address, image_url) VALUES ('Hoi An Ancient Town', 'H21', 'Allegro Hoi An - A Little Luxury Hotel & Spa', '02353911111', {street: '86 Tran Hung Dao, Cam Pho', city: 'Hoi An', state_or_province: 'Hoi An', postal_code: '560000', country: 'VN'}, '/images/KhachSan21.webp');
INSERT INTO hotels_by_poi (poi_name, hotel_id, name, phone, address, image_url) VALUES ('Hoi An Ancient Town', 'H22', 'La Charm Hoi An Hotel', '02353922222', {street: '64 Nguyen Thai Hoc, Minh An', city: 'Hoi An', state_or_province: 'Hoi An', postal_code: '560000', country: 'VN'}, '/images/KhachSan22.webp');
INSERT INTO hotels_by_poi (poi_name, hotel_id, name, phone, address, image_url) VALUES ('Hoi An Ancient Town', 'H23', 'Hoi An Historic Hotel', '02353936666', {street: '10 Tran Hung Dao, Son Phong', city: 'Hoi An', state_or_province: 'Hoi An', postal_code: '560000', country: 'VN'}, '/images/KhachSan23.webp');
INSERT INTO hotels_by_poi (poi_name, hotel_id, name, phone, address, image_url) VALUES ('Hoi An Ancient Town', 'H24', 'Laluna Hoi An Riverside Hotel & Spa', '02353937777', {street: '12 Nguyen Du, Cam Pho', city: 'Hoi An', state_or_province: 'Hoi An', postal_code: '560000', country: 'VN'}, '/images/KhachSan24.webp');
INSERT INTO hotels_by_poi (poi_name, hotel_id, name, phone, address, image_url) VALUES ('Hoi An Ancient Town', 'H25', 'Golden River Hotel Hoi An', '02353938888', {street: '04 Nguyen Phuc Nguyen, Cam Pho', city: 'Hoi An', state_or_province: 'Hoi An', postal_code: '560000', country: 'VN'}, '/images/KhachSan25.webp');

-- ============================================================
-- 3. DU LIEU PHONG: 2 PHONG MAU / KHACH SAN
-- ============================================================
INSERT INTO rooms_by_hotel (hotel_id, room_number, capacity, price) VALUES ('H01', 101, 2, 500000);
INSERT INTO rooms_by_hotel (hotel_id, room_number, capacity, price) VALUES ('H01', 102, 4, 800000);
INSERT INTO rooms_by_hotel (hotel_id, room_number, capacity, price) VALUES ('H02', 101, 2, 650000);
INSERT INTO rooms_by_hotel (hotel_id, room_number, capacity, price) VALUES ('H02', 102, 4, 950000);
INSERT INTO rooms_by_hotel (hotel_id, room_number, capacity, price) VALUES ('H03', 101, 2, 800000);
INSERT INTO rooms_by_hotel (hotel_id, room_number, capacity, price) VALUES ('H03', 102, 4, 1100000);
INSERT INTO rooms_by_hotel (hotel_id, room_number, capacity, price) VALUES ('H04', 101, 2, 950000);
INSERT INTO rooms_by_hotel (hotel_id, room_number, capacity, price) VALUES ('H04', 102, 4, 1250000);
INSERT INTO rooms_by_hotel (hotel_id, room_number, capacity, price) VALUES ('H05', 101, 2, 1100000);
INSERT INTO rooms_by_hotel (hotel_id, room_number, capacity, price) VALUES ('H05', 102, 4, 1400000);
INSERT INTO rooms_by_hotel (hotel_id, room_number, capacity, price) VALUES ('H06', 101, 2, 500000);
INSERT INTO rooms_by_hotel (hotel_id, room_number, capacity, price) VALUES ('H06', 102, 4, 800000);
INSERT INTO rooms_by_hotel (hotel_id, room_number, capacity, price) VALUES ('H07', 101, 2, 650000);
INSERT INTO rooms_by_hotel (hotel_id, room_number, capacity, price) VALUES ('H07', 102, 4, 950000);
INSERT INTO rooms_by_hotel (hotel_id, room_number, capacity, price) VALUES ('H08', 101, 2, 800000);
INSERT INTO rooms_by_hotel (hotel_id, room_number, capacity, price) VALUES ('H08', 102, 4, 1100000);
INSERT INTO rooms_by_hotel (hotel_id, room_number, capacity, price) VALUES ('H09', 101, 2, 950000);
INSERT INTO rooms_by_hotel (hotel_id, room_number, capacity, price) VALUES ('H09', 102, 4, 1250000);
INSERT INTO rooms_by_hotel (hotel_id, room_number, capacity, price) VALUES ('H10', 101, 2, 1100000);
INSERT INTO rooms_by_hotel (hotel_id, room_number, capacity, price) VALUES ('H10', 102, 4, 1400000);
INSERT INTO rooms_by_hotel (hotel_id, room_number, capacity, price) VALUES ('H11', 101, 2, 500000);
INSERT INTO rooms_by_hotel (hotel_id, room_number, capacity, price) VALUES ('H11', 102, 4, 800000);
INSERT INTO rooms_by_hotel (hotel_id, room_number, capacity, price) VALUES ('H12', 101, 2, 650000);
INSERT INTO rooms_by_hotel (hotel_id, room_number, capacity, price) VALUES ('H12', 102, 4, 950000);
INSERT INTO rooms_by_hotel (hotel_id, room_number, capacity, price) VALUES ('H13', 101, 2, 800000);
INSERT INTO rooms_by_hotel (hotel_id, room_number, capacity, price) VALUES ('H13', 102, 4, 1100000);
INSERT INTO rooms_by_hotel (hotel_id, room_number, capacity, price) VALUES ('H14', 101, 2, 950000);
INSERT INTO rooms_by_hotel (hotel_id, room_number, capacity, price) VALUES ('H14', 102, 4, 1250000);
INSERT INTO rooms_by_hotel (hotel_id, room_number, capacity, price) VALUES ('H15', 101, 2, 1100000);
INSERT INTO rooms_by_hotel (hotel_id, room_number, capacity, price) VALUES ('H15', 102, 4, 1400000);
INSERT INTO rooms_by_hotel (hotel_id, room_number, capacity, price) VALUES ('H16', 101, 2, 500000);
INSERT INTO rooms_by_hotel (hotel_id, room_number, capacity, price) VALUES ('H16', 102, 4, 800000);
INSERT INTO rooms_by_hotel (hotel_id, room_number, capacity, price) VALUES ('H17', 101, 2, 650000);
INSERT INTO rooms_by_hotel (hotel_id, room_number, capacity, price) VALUES ('H17', 102, 4, 950000);
INSERT INTO rooms_by_hotel (hotel_id, room_number, capacity, price) VALUES ('H18', 101, 2, 800000);
INSERT INTO rooms_by_hotel (hotel_id, room_number, capacity, price) VALUES ('H18', 102, 4, 1100000);
INSERT INTO rooms_by_hotel (hotel_id, room_number, capacity, price) VALUES ('H19', 101, 2, 950000);
INSERT INTO rooms_by_hotel (hotel_id, room_number, capacity, price) VALUES ('H19', 102, 4, 1250000);
INSERT INTO rooms_by_hotel (hotel_id, room_number, capacity, price) VALUES ('H20', 101, 2, 1100000);
INSERT INTO rooms_by_hotel (hotel_id, room_number, capacity, price) VALUES ('H20', 102, 4, 1400000);
INSERT INTO rooms_by_hotel (hotel_id, room_number, capacity, price) VALUES ('H21', 101, 2, 500000);
INSERT INTO rooms_by_hotel (hotel_id, room_number, capacity, price) VALUES ('H21', 102, 4, 800000);
INSERT INTO rooms_by_hotel (hotel_id, room_number, capacity, price) VALUES ('H22', 101, 2, 650000);
INSERT INTO rooms_by_hotel (hotel_id, room_number, capacity, price) VALUES ('H22', 102, 4, 950000);
INSERT INTO rooms_by_hotel (hotel_id, room_number, capacity, price) VALUES ('H23', 101, 2, 800000);
INSERT INTO rooms_by_hotel (hotel_id, room_number, capacity, price) VALUES ('H23', 102, 4, 1100000);
INSERT INTO rooms_by_hotel (hotel_id, room_number, capacity, price) VALUES ('H24', 101, 2, 950000);
INSERT INTO rooms_by_hotel (hotel_id, room_number, capacity, price) VALUES ('H24', 102, 4, 1250000);
INSERT INTO rooms_by_hotel (hotel_id, room_number, capacity, price) VALUES ('H25', 101, 2, 1100000);
INSERT INTO rooms_by_hotel (hotel_id, room_number, capacity, price) VALUES ('H25', 102, 4, 1400000);

-- ============================================================
-- 4. DU LIEU PHONG TRONG THEO NGAY
-- ============================================================
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H01', '2026-10-01', 101, false);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H01', '2026-10-01', 102, true);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H01', '2026-10-02', 101, true);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H01', '2026-10-02', 102, false);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H02', '2026-10-01', 101, true);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H02', '2026-10-01', 102, false);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H02', '2026-10-02', 101, true);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H02', '2026-10-02', 102, true);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H03', '2026-10-01', 101, true);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H03', '2026-10-01', 102, true);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H03', '2026-10-02', 101, false);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H03', '2026-10-02', 102, false);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H04', '2026-10-01', 101, false);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H04', '2026-10-01', 102, false);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H04', '2026-10-02', 101, true);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H04', '2026-10-02', 102, true);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H05', '2026-10-01', 101, true);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H05', '2026-10-01', 102, true);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H05', '2026-10-02', 101, true);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H05', '2026-10-02', 102, false);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H06', '2026-10-01', 101, true);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H06', '2026-10-01', 102, false);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H06', '2026-10-02', 101, false);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H06', '2026-10-02', 102, true);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H07', '2026-10-01', 101, false);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H07', '2026-10-01', 102, true);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H07', '2026-10-02', 101, true);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H07', '2026-10-02', 102, false);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H08', '2026-10-01', 101, true);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H08', '2026-10-01', 102, false);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H08', '2026-10-02', 101, true);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H08', '2026-10-02', 102, true);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H09', '2026-10-01', 101, true);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H09', '2026-10-01', 102, true);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H09', '2026-10-02', 101, false);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H09', '2026-10-02', 102, false);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H10', '2026-10-01', 101, false);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H10', '2026-10-01', 102, false);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H10', '2026-10-02', 101, true);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H10', '2026-10-02', 102, true);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H11', '2026-10-01', 101, true);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H11', '2026-10-01', 102, true);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H11', '2026-10-02', 101, true);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H11', '2026-10-02', 102, false);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H12', '2026-10-01', 101, true);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H12', '2026-10-01', 102, false);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H12', '2026-10-02', 101, false);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H12', '2026-10-02', 102, true);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H13', '2026-10-01', 101, false);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H13', '2026-10-01', 102, true);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H13', '2026-10-02', 101, true);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H13', '2026-10-02', 102, false);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H14', '2026-10-01', 101, true);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H14', '2026-10-01', 102, false);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H14', '2026-10-02', 101, true);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H14', '2026-10-02', 102, true);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H15', '2026-10-01', 101, true);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H15', '2026-10-01', 102, true);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H15', '2026-10-02', 101, false);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H15', '2026-10-02', 102, false);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H16', '2026-10-01', 101, false);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H16', '2026-10-01', 102, false);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H16', '2026-10-02', 101, true);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H16', '2026-10-02', 102, true);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H17', '2026-10-01', 101, true);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H17', '2026-10-01', 102, true);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H17', '2026-10-02', 101, true);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H17', '2026-10-02', 102, false);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H18', '2026-10-01', 101, true);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H18', '2026-10-01', 102, false);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H18', '2026-10-02', 101, false);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H18', '2026-10-02', 102, true);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H19', '2026-10-01', 101, false);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H19', '2026-10-01', 102, true);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H19', '2026-10-02', 101, true);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H19', '2026-10-02', 102, false);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H20', '2026-10-01', 101, true);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H20', '2026-10-01', 102, false);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H20', '2026-10-02', 101, true);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H20', '2026-10-02', 102, true);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H21', '2026-10-01', 101, true);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H21', '2026-10-01', 102, true);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H21', '2026-10-02', 101, false);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H21', '2026-10-02', 102, false);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H22', '2026-10-01', 101, false);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H22', '2026-10-01', 102, false);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H22', '2026-10-02', 101, true);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H22', '2026-10-02', 102, true);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H23', '2026-10-01', 101, true);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H23', '2026-10-01', 102, true);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H23', '2026-10-02', 101, true);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H23', '2026-10-02', 102, false);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H24', '2026-10-01', 101, true);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H24', '2026-10-01', 102, false);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H24', '2026-10-02', 101, false);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H24', '2026-10-02', 102, true);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H25', '2026-10-01', 101, false);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H25', '2026-10-01', 102, true);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H25', '2026-10-02', 101, true);
INSERT INTO available_rooms_by_hotel_date (hotel_id, date, room_number, is_available) VALUES ('H25', '2026-10-02', 102, false);

-- ============================================================
-- 5. DU LIEU KHACH HANG
-- ============================================================
INSERT INTO guests (guest_id, first_name, last_name, title, email, phone_numbers, addresses) VALUES ('G01', 'An', 'Nguyen Van', 'Mr.', 'nguyenvana@gmail.com', {'0901234567'}, {'home': {street: '45 Le Loi', city: 'HCM', state_or_province: 'HCM', postal_code: '700000', country: 'VN'}});
INSERT INTO guests (guest_id, first_name, last_name, title, email, phone_numbers, addresses) VALUES ('G02', 'Binh', 'Tran Thi', 'Ms.', 'tranthibinh@gmail.com', {'0908765432'}, {'home': {street: '12 Nam Ky Khoi Nghia', city: 'HCM', state_or_province: 'HCM', postal_code: '700000', country: 'VN'}});
INSERT INTO guests (guest_id, first_name, last_name, title, email, phone_numbers, addresses) VALUES ('G03', 'Cuong', 'Le Minh', 'Mr.', 'leminhcuong@gmail.com', {'0933112233'}, {'home': {street: '88 Nguyen Du', city: 'HCM', state_or_province: 'HCM', postal_code: '700000', country: 'VN'}});
INSERT INTO guests (guest_id, first_name, last_name, title, email, phone_numbers, addresses) VALUES ('G04', 'Dung', 'Pham Thi', 'Ms.', 'phamthidung@gmail.com', {'0911223344'}, {'home': {street: '20 Tran Hung Dao', city: 'Hanoi', state_or_province: 'Hanoi', postal_code: '100000', country: 'VN'}});
INSERT INTO guests (guest_id, first_name, last_name, title, email, phone_numbers, addresses) VALUES ('G05', 'Hoa', 'Vo Thanh', 'Ms.', 'vothanhhoa@gmail.com', {'0988776655'}, {'home': {street: '15 Bach Dang', city: 'Da Nang', state_or_province: 'Da Nang', postal_code: '550000', country: 'VN'}});

-- ============================================================
-- 6. DU LIEU DAT PHONG - DONG BO 3 BANG RESERVATIONS
-- ============================================================
INSERT INTO reservations_by_hotel_date (hotel_id, start_date, room_number, end_date, confirm_number, guest_id) VALUES ('H01', '2026-10-01', 101, '2026-10-05', 'CF200001', 'G01');
INSERT INTO reservations_by_confirmation (confirm_number, hotel_id, room_number, start_date, end_date, guest_id) VALUES ('CF200001', 'H01', 101, '2026-10-01', '2026-10-05', 'G01');
INSERT INTO reservations_by_guest (guest_last_name, hotel_id, guest_id, room_number, start_date, end_date, confirm_number) VALUES ('Nguyen Van', 'H01', 'G01', 101, '2026-10-01', '2026-10-05', 'CF200001');
INSERT INTO reservations_by_hotel_date (hotel_id, start_date, room_number, end_date, confirm_number, guest_id) VALUES ('H06', '2026-10-02', 102, '2026-10-04', 'CF200002', 'G02');
INSERT INTO reservations_by_confirmation (confirm_number, hotel_id, room_number, start_date, end_date, guest_id) VALUES ('CF200002', 'H06', 102, '2026-10-02', '2026-10-04', 'G02');
INSERT INTO reservations_by_guest (guest_last_name, hotel_id, guest_id, room_number, start_date, end_date, confirm_number) VALUES ('Tran Thi', 'H06', 'G02', 102, '2026-10-02', '2026-10-04', 'CF200002');
INSERT INTO reservations_by_hotel_date (hotel_id, start_date, room_number, end_date, confirm_number, guest_id) VALUES ('H11', '2026-10-03', 101, '2026-10-06', 'CF200003', 'G03');
INSERT INTO reservations_by_confirmation (confirm_number, hotel_id, room_number, start_date, end_date, guest_id) VALUES ('CF200003', 'H11', 101, '2026-10-03', '2026-10-06', 'G03');
INSERT INTO reservations_by_guest (guest_last_name, hotel_id, guest_id, room_number, start_date, end_date, confirm_number) VALUES ('Le Minh', 'H11', 'G03', 101, '2026-10-03', '2026-10-06', 'CF200003');
INSERT INTO reservations_by_hotel_date (hotel_id, start_date, room_number, end_date, confirm_number, guest_id) VALUES ('H16', '2026-10-04', 102, '2026-10-08', 'CF200004', 'G04');
INSERT INTO reservations_by_confirmation (confirm_number, hotel_id, room_number, start_date, end_date, guest_id) VALUES ('CF200004', 'H16', 102, '2026-10-04', '2026-10-08', 'G04');
INSERT INTO reservations_by_guest (guest_last_name, hotel_id, guest_id, room_number, start_date, end_date, confirm_number) VALUES ('Pham Thi', 'H16', 'G04', 102, '2026-10-04', '2026-10-08', 'CF200004');
INSERT INTO reservations_by_hotel_date (hotel_id, start_date, room_number, end_date, confirm_number, guest_id) VALUES ('H21', '2026-10-05', 101, '2026-10-07', 'CF200005', 'G05');
INSERT INTO reservations_by_confirmation (confirm_number, hotel_id, room_number, start_date, end_date, guest_id) VALUES ('CF200005', 'H21', 101, '2026-10-05', '2026-10-07', 'G05');
INSERT INTO reservations_by_guest (guest_last_name, hotel_id, guest_id, room_number, start_date, end_date, confirm_number) VALUES ('Vo Thanh', 'H21', 'G05', 101, '2026-10-05', '2026-10-07', 'CF200005');

-- ============================================================
-- 7. CAC TRUY VAN MAU Q1-Q9
-- ============================================================
-- Q1. Tra cuu thong tin chi tiet cua khach san theo ID
SELECT * FROM hotels WHERE id = 'H01';

-- Q2. Tra cuu danh sach khach san gan diem quan tam
SELECT * FROM hotels_by_poi WHERE poi_name = 'Ben Thanh Market';

-- Q3. Tra cuu danh sach phong cua mot khach san
SELECT * FROM rooms_by_hotel WHERE hotel_id = 'H01';

-- Q4. Tra cuu phong con trong cua khach san theo ngay
SELECT * FROM available_rooms_by_hotel_date
WHERE hotel_id = 'H01' AND date = '2026-10-01';

-- Q5. Tra cuu cac dat phong tai khach san theo ngay bat dau
SELECT * FROM reservations_by_hotel_date
WHERE hotel_id = 'H01' AND start_date = '2026-10-01';

-- Q6. Tra cuu thong tin dat phong theo ma xac nhan
SELECT * FROM reservations_by_confirmation
WHERE confirm_number = 'CF200001';

-- Q7. Tra cuu dat phong theo ho cua khach hang
SELECT * FROM reservations_by_guest
WHERE guest_last_name = 'Nguyen Van';

-- Q8. Tra cuu dat phong theo ho tai mot khach san cu the
SELECT * FROM reservations_by_guest
WHERE guest_last_name = 'Nguyen Van' AND hotel_id = 'H01';

-- Q9. Xem thong tin chi tiet khach hang theo Guest ID
SELECT * FROM guests WHERE guest_id = 'G01';