PRAGMA foreign_keys=ON;
CREATE TABLE brands(id INTEGER PRIMARY KEY, name TEXT NOT NULL COLLATE BINARY UNIQUE);

CREATE TABLE categories(id INTEGER PRIMARY KEY,name TEXT NOT NULL UNIQUE);

CREATE TABLE metadata(key TEXT PRIMARY KEY,value TEXT NOT NULL);

CREATE TABLE observations(id INTEGER PRIMARY KEY,product_id INTEGER REFERENCES products(id),source_file_id INTEGER REFERENCES source_files(id),source_row_id INTEGER,raw_record_json TEXT NOT NULL,image_status TEXT,image_path TEXT,original_image_file TEXT,details_json TEXT,UNIQUE(source_file_id,source_row_id));

CREATE TABLE product_categories(product_id INTEGER REFERENCES products(id),category_id INTEGER REFERENCES categories(id),PRIMARY KEY(product_id,category_id));

CREATE TABLE products(id INTEGER PRIMARY KEY,source_product_id TEXT NOT NULL UNIQUE,"full_name" TEXT, "brand_method" TEXT, "capacity_text" TEXT, "capacity_value" REAL, "capacity_unit" TEXT, "pack_count" INTEGER, "price_toman" INTEGER, "original_price_toman" INTEGER, "price_type" TEXT, "image_kind" TEXT, "needs_review" INTEGER, "review_notes" TEXT, "source_card_text" TEXT,image_path TEXT,image_present INTEGER NOT NULL,has_conflict INTEGER NOT NULL DEFAULT 0, brand_id INTEGER REFERENCES brands(id));

CREATE TABLE source_files(id INTEGER PRIMARY KEY,path TEXT,sha256 TEXT,category_id INTEGER REFERENCES categories(id),metadata_json TEXT);

CREATE INDEX idx_observations_product ON observations(product_id);

CREATE INDEX idx_products_brand_id ON products(brand_id);

CREATE VIEW product_catalog AS
SELECT p.*, b.name AS brand, c.name AS category
FROM products p
LEFT JOIN brands b ON b.id=p.brand_id
JOIN product_categories pc ON p.id=pc.product_id
JOIN categories c ON c.id=pc.category_id;
