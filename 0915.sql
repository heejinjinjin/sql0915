-- DDL: 데이터정의어

-- 고객 정보(newcustomer table)
-- custid, name, address, phone
create table newcustomer(
    custid number primary key,
    name VARCHAR2(40),
    address VARCHAR2(40),
    phone VARCHAR2(30)
);
-- 주문 정보(neworders table)
-- orderid(기본키)
-- custid(not null, new customer custid 참조해서 외래키, 연쇄 삭제)
-- bookid(not null, newbook3 bookid 참조해서 외래키, 연쇄삭제)
-- saleprce
-- orderdate(date)
create table neworders(
    orderid number primary key,
    custid number not null,
    bookid number not null,
    saleprice number,
    orderdate date,
    FOREIGN key(custid) REFERENCES newcustomer(custid)on delete cascade,
    FOREIGN key(bookid) REFERENCES newbook3(bookid)on delete cascade
);

-- Alter문
-- 이미 생성된 테이블의 구조를 변경할 때 사용
-- add 추가, drop 삭제, modify 수정

-- 기존의 newbook1 테이블을 삭제하고 새 테이블 작성
create table newbook1(
    bookid number,
    bookname VARCHAR2(20),
    publisher VARCHAR2(20),
    price number
);

-- isbn 컬럼 추가
alter table newbook1
add isbn VARCHAR2(13);

-- isbn 컬럼의 자료형 변경
alter table newbook1
modify isbn number;

-- isbn 컬럼 삭제
alter table newbook1 drop column isbn;

-- bookname 컬럼의 varchar2(30) not null 제약조건 변경
alter table newbook1
modify bookname varchar2(30) not null;

-- bookid 컬럼에 not null 제약조건
alter table newbook1
modify bookid number not null;

-- bookid 컬럼의 기본키 추가
alter table newbook1
add primary key(bookid);

-- 테이블 삭제
drop table newbook1;

-- DML(select 추가, insert 삽입, update 수정, delete 삭제)
-- insert 1번: 속성리스트 생략
insert into book
values(11, '개미', '해냄', 12000);

-- insert 2번: 속성(컬럼)리스트 명시 
insert into book(bookid, bookname, publisher, price)
values(12, '나의라임오렌지나무', '좋은책', 8000);

-- insert 3번: 컬럼의 순서를 변경
insert into book(bookid, price, publisher, bookname)
values(13, 28000, '부자나라', '부의 습관');

-- insert 4번: 특정 컬럼의 값을 생략
insert into book(bookid, price, bookname)
values(14, 10000, '아침 명상');

-- 테이블 구조가 같은 다른 테이블의 데이터행 삽입하는 방법
insert into book(bookid, bookname, price, publisher)
select bookid, bookname, price, publisher
from imported_book;

-- update: 데이터 변경
-- 고객번호가 5번인 고객의 주소를 대한민국 부산 변경하시오.
select * from customer;
update customer
set address='대한민국 부산'
where custid=5;

-- 박세리 고객의 주소를 김연아 고개긔 주소와 동일하게 변경하시오
update customer
set address=(select address
                from customer
                where name='김연아')
where name='박세리';

-- 박세리 고객의 전화번호를 김연아 고객의 전화번호와 동일하게 변경하시오
update customer
set phone=(select phone
                from customer
                where name='김연아')
where name='박세리';

-- 모든 고객을 삭제하시오
delete from customer;

select * from orders;
select * from customer;

-- 박세리 고객을 삭제하시오
delete from customer
where name='박세리';

rollback;
commit;

-- 박지성이 구매한 도서의 출판사와 같은 출판사에서 도서를 구매한 고객의 이름
select name from customer where custid
in (select custid from orders where bookid
in (select bookid from book where publisher 
in (select publisher from book, orders, customer 
where customer.custid=orders.custid 
and book.bookid=orders.bookid and name like '박지성')));