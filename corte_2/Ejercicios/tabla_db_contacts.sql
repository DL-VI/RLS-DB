CREATE TABLE categories (
    cont_id SERIAL PRIMARY KEY,
    name VARCHAR(20) NOT NULL
);

CREATE TABLE contacts (
    c_ID SERIAL PRIMARY KEY,
    name VARCHAR(20) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(30) UNIQUE NOT NULL,
    summary VARCHAR(30) NOT NULL,
    nickname VARCHAR(20) NOT NULL,
    address VARCHAR(30) NOT NULL,
    cat_id INTEGER NOT NULL,
    FOREIGN KEY (cat_id) REFERENCES categories (cont_id)
);
