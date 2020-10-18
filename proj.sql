set schema FN45449;

CREATE TABLE PRODUCTS(
    PRODUCTID INTEGER NOT NULL CONSTRAINT PK_PRODUCTS PRIMARY KEY GENERATED ALWAYS AS IDENTITY ,
    NAME VARCHAR(60) NOT NULL,
    CATALOG_PRICE DOUBLE NOT NULL
);

CREATE TABLE SALES (
    SALEID INTEGER  NOT NULL CONSTRAINT PK_SALES PRIMARY KEY GENERATED ALWAYS AS IDENTITY ,
    DATE_OF_COMPLETION DATE,
    CLIENTID INTEGER NOT NULL CONSTRAINT FK_CLIENTS REFERENCES CLIENTS(CLIENTID),
    USERID INTEGER NOT NULL CONSTRAINT FK_USERS REFERENCES FN45449.USERS(USERID)
);

CREATE TABLE PRODUCTS_SOLD(
    REGID INTEGER NOT NULL CONSTRAINT PK_PRODUCTS_SOLD PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    SALEID INTEGER NOT NULL CONSTRAINT FK_SALES REFERENCES SALES(SALEID),
    PRODUCTID INTEGER NOT NULL CONSTRAINT FK_PRODUCTS REFERENCES PRODUCTS(PRODUCTID),
    QUANTITY DOUBLE NOT NULL,
    TOTALPRICE DOUBLE NOT NULL
);

CREATE TABLE CLIENTS(
    CLIENTID INTEGER NOT NULL CONSTRAINT PK_CLIENTS PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    NAME VARCHAR(40) NOT NULL,
    COMPANY_NAME VARCHAR(40),
    COMPANY_UIC VARCHAR(20),
    VAT VARCHAR(22),
    CLIENT_ADDRESS VARCHAR(60)
);

CREATE TABLE USERS(
    USERID INTEGER NOT NULL CONSTRAINT PK__USERS PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    USERNAME VARCHAR(20) NOT NULL,
    PASSWORD VARCHAR(20) NOT NULL,
    EMPLOYEENAME VARCHAR(30) NOT NULL
);

ALTER TABLE FN45449.USERS ADD CONSTRAINT MIN_LEN_CONSTRAINT CHECK(LENGTH(USERNAME)>5 );
ALTER TABLE FN45449.PRODUCTS_SOLD ADD CONSTRAINT NON_NEG_QUANTITY CHECK (FN45449.PRODUCTS_SOLD.QUANTITY>0 );
ALTER TABLE FN45449.PRODUCTS_SOLD ADD CONSTRAINT NON_NEG_TOTALPRICE CHECK ( FN45449.PRODUCTS_SOLD.TOTALPRICE>0 );
ALTER TABLE FN45449.PRODUCTS ADD CONSTRAINT NON_NEG_CATALOG_PRICE CHECK ( FN45449.PRODUCTS.CATALOG_PRICE>0 );
ALTER TABLE FN45449.SALES ADD CONSTRAINT FK_USERS FOREIGN KEY(USERID) REFERENCES FN45449.USERS(USERID);
ALTER TABLE FN45449.USERS ADD CONSTRAINT UserNameUnique UNIQUE (USERNAME);




DROP TABLE FN45449.DUMMY;
CREATE TABLE DUMMY (
    HEADCOUNT INT NOT NULL DEFAULT 0,CHECK ( FN45449.DUMMY.HEADCOUNT>=0 ),
    TRASH_CAN_VALUE VARCHAR(100)
);