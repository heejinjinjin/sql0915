-- DDL: ���������Ǿ�

-- �� ����(newcustomer table)
-- custid, name, address, phone
create table newcustomer(
    custid number primary key,
    name VARCHAR2(40),
    address VARCHAR2(40),
    phone VARCHAR2(30)
);
-- �ֹ� ����(neworders table)
-- orderid(�⺻Ű)
-- custid(not null, new customer custid �����ؼ� �ܷ�Ű, ���� ����)
-- bookid(not null, newbook3 bookid �����ؼ� �ܷ�Ű, �������)
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

-- Alter��
-- �̹� ������ ���̺��� ������ ������ �� ���
-- add �߰�, drop ����, modify ����

-- ������ newbook1 ���̺��� �����ϰ� �� ���̺� �ۼ�
create table newbook1(
    bookid number,
    bookname VARCHAR2(20),
    publisher VARCHAR2(20),
    price number
);

-- isbn �÷� �߰�
alter table newbook1
add isbn VARCHAR2(13);

-- isbn �÷��� �ڷ��� ����
alter table newbook1
modify isbn number;

-- isbn �÷� ����
alter table newbook1 drop column isbn;

-- bookname �÷��� varchar2(30) not null �������� ����
alter table newbook1
modify bookname varchar2(30) not null;

-- bookid �÷��� not null ��������
alter table newbook1
modify bookid number not null;

-- bookid �÷��� �⺻Ű �߰�
alter table newbook1
add primary key(bookid);

-- ���̺� ����
drop table newbook1;

-- DML(select �߰�, insert ����, update ����, delete ����)
-- insert 1��: �Ӽ�����Ʈ ����
insert into book
values(11, '����', '�س�', 12000);

-- insert 2��: �Ӽ�(�÷�)����Ʈ ��� 
insert into book(bookid, bookname, publisher, price)
values(12, '���Ƕ��ӿ���������', '����å', 8000);

-- insert 3��: �÷��� ������ ����
insert into book(bookid, price, publisher, bookname)
values(13, 28000, '���ڳ���', '���� ����');

-- insert 4��: Ư�� �÷��� ���� ����
insert into book(bookid, price, bookname)
values(14, 10000, '��ħ ���');

-- ���̺� ������ ���� �ٸ� ���̺��� �������� �����ϴ� ���
insert into book(bookid, bookname, price, publisher)
select bookid, bookname, price, publisher
from imported_book;

-- update: ������ ����
-- ����ȣ�� 5���� ���� �ּҸ� ���ѹα� �λ� �����Ͻÿ�.
select * from customer;
update customer
set address='���ѹα� �λ�'
where custid=5;

-- �ڼ��� ���� �ּҸ� �迬�� ���� �ּҿ� �����ϰ� �����Ͻÿ�
update customer
set address=(select address
                from customer
                where name='�迬��')
where name='�ڼ���';

-- �ڼ��� ���� ��ȭ��ȣ�� �迬�� ���� ��ȭ��ȣ�� �����ϰ� �����Ͻÿ�
update customer
set phone=(select phone
                from customer
                where name='�迬��')
where name='�ڼ���';

-- ��� ���� �����Ͻÿ�
delete from customer;

select * from orders;
select * from customer;

-- �ڼ��� ���� �����Ͻÿ�
delete from customer
where name='�ڼ���';

rollback;
commit;

-- �������� ������ ������ ���ǻ�� ���� ���ǻ翡�� ������ ������ ���� �̸�
select name from customer where custid
in (select custid from orders where bookid
in (select bookid from book where publisher 
in (select publisher from book, orders, customer 
where customer.custid=orders.custid 
and book.bookid=orders.bookid and name like '������')));