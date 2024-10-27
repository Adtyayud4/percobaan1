-- Seorang pelanggan bernama Adit ingin membeli beberapa game, sebelum dia memilih game yang dia inginkan, 
-- adit diminta memberikan beberapa informasi data dirinya sebagai berikut
--Customer Information:
-- Customer Name: Aditya Yuda
-- Customer Gender: Male
-- Customer Date of Birth: 17th February 2003
-- Customer Phone: 08137911878

INSERT INTO MsCustomer VALUES 
('CU011','Aditya Yuda','Male','2003-02-17','08137911878')

-- Pada Tanggal 27 February 2023, Aditya Yuda yang dilayani oleh staff bernama Akmal Miller membeli beberapa Game:
-- 1. Game The Buider 3 sebanyak 2
-- 2. Game Gula Rush Sebanyak 1

INSERT INTO SaleHeader VALUES
('SA021', 'ST003', 'CU011', '2023-02-27')
INSERT INTO SaleDetail VALUES
('SA021','GA001','2'),
('SA021','GA009','1')

-- Sebuah Game suplier game mengajukan penawaran untuk menjualkan gamenya kepada GoGame. 
-- Mereka berdiskusi tentang harga, persyaratan penjualan, dan keuntungan yang bisa diperoleh. Setelah mencapai kesepakatan, 
-- kedua belah pihak menandatangani kontrak penjualan Dan Suplier tersebut memberikan beberapa Informasi Perusahaan untuk didata.
-- berikut adalah informasi tersebut
-- Supplier Name: Mark Game
-- Supplier Address: 199-28 Pungnap-dong, Songpa-gu, Seoul
-- Supplier Phone: 081379118865

INSERT INTO MsSupplier VALUES 
('SU011','Mark Game','199-28 Pungnap-dong, Songpa-gu, Seoul','081379118865')

-- Pada Tanggal 18 Juni 2023, perusahaan Mark Game yang dilayani oleh staff bernama Jenni Lee Menjual beberapa Game:
-- 1. Game Infinite Challenge dengan tipe game Multiplayer sebanyak 1 dengan harga masing 280000 yang rilis pada tanggal 13 Juni 2023
-- 2. Game Going Kart dengan tipe game Racing sebanyak 1 dengan harga masing 250000 yang rilis pada tanggal 09 Mei 2023
INSERT INTO MsGame VALUES
('GA011','GT009', 'Infinite Challenge', 240000, '2023-06-01'),
('GA012','GT005', 'Going Kart', 150000, '2023-05-09')

INSERT INTO PurchaseHeader VALUES
('PU021', 'ST001', 'SU011', '2023-06-18')

INSERT INTO PurchaseDetail VALUES
('PU021','GA011','1'),
('PU021','GA012','1')

