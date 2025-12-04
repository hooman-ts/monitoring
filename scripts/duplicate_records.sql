create table Users ( UserID varchar(30) ); 

insert into Users values ('MAX'); 
insert into Users values ('STEPHANIE'); 
insert into Users values ('BOB'); 
insert into Users values ('BOB'); 
insert into Users values ('FRED'); 
insert into Users values ('SALLY'); 
insert into Users values ('FRED'); 
insert into Users values ('SALLY'); 
insert into Users values ('BOB'); 
insert into Users values ('BOB'); 
insert into Users values ('SALLY'); 
insert into Users values ('BOB'); 
insert into Users values ('SALLY');


select UserID, count(*) from Users group by UserID having count(*) > 1;


select rowid, userid from users
order by userid;

DELETE FROM users
WHERE rowid not in
(SELECT MIN(rowid)
FROM users
GROUP BY userid);