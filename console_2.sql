create schema FN45449;

create table CLIENTS
(
	CLIENTID INTEGER
		constraint PK_CLIENTS
			primary key,
	NAME VARCHAR(40) not null,
	COMPANY_NAME VARCHAR(40),
	COMPANY_UIC VARCHAR(20),
	VAT VARCHAR(22),
	CLIENT_ADDRESS VARCHAR(60)
);

create table PRODUCTS
(
	PRODUCTID INTEGER
		constraint PK_PRODUCTS
			primary key,
	NAME VARCHAR(60) not null,
	CATALOG_PRICE DOUBLE not null
);

create table SALES
(
	SALEID INTEGER
		constraint PK_SALES
			primary key,
	DATE_OF_COMPLETION DATE,
	CLIENTID INTEGER not null
		constraint FK_CLIENTS
			references CLIENTS,
	USERID INTEGER not null
);

create table PRODUCTS_SOLD
(
	REGID INTEGER
		constraint PK_PRODUCTS_SOLD
			primary key,
	SALEID INTEGER not null
		constraint FK_SALES
			references SALES,
	PRODUCTID INTEGER not null
		constraint FK_PRODUCTS
			references PRODUCTS,
	QUANTITY DOUBLE not null,
	TOTALPRICE DOUBLE not null
);

create table USERS
(
	USERID INTEGER
		constraint PK__USERS
			primary key,
	USERNAME VARCHAR(20) not null,
	PASSWORD VARCHAR(20) not null,
	EMPLOYEENAME VARCHAR(30) not null
);

CREATE OR REPLACE VIEW USERS_VIEW
AS
    SELECT USERNAME,EMPLOYEENAME
    FROM FN45449.USERS;

