show databases;
use test; 
show tables;


-- creating student table
create table student(
	ID varchar(10) not null unique primary key,
    stud_name varchar(20) not null,
    department varchar(10) not null,
    cgpa int
    );
insert into student values("S001","ARUN","CS",8),
						  ("S002","GITA","CS",7.5),
						  ("S003","KUMAR","IT",6),
                          ("S004","ROHIT","IT",8.5),
                          ("S005","YAMUNA","ECE",9),
                          ("S006","YOGESH","ECE",9);
    
-- creating company table
create table company(
	ID varchar(10) not null unique primary key,
    comp_name varchar(50) not null,
    location varchar(50) not null,
    interview date
    );
insert into company values("C001","MICROSOFT","BANGALORE",'2020-08-01'),
						  ("C002","AMAZON","CHENNAI",'2020-09-10'),
						  ("C003","FLIPKART","BANGALORE",'2020-09-15'),
                          ("C004","HONEYWELL","HYDERBAD",'2020-10-30'),
                          ("C005","ACCENTURE","CHENNAI",'2020-11-30'),
                          ("C006","WIPRO","NOIDA",'2020-12-31');
    
-- creting placement table
create table placement(
	S_ID varchar(10) not null,
    C_ID varchar(10) not null,
    package bigInt,
	foreign key(S_ID)
    references student(ID),
    foreign key(C_ID)
    references company(ID)
    );
insert into placement values("S001","C001",2000000),
						  ("S002","C001",2000000),
						  ("S003","C002",1200000),
                          ("S004","C004",700000),
                          ("S004","C006",400000),
                          ("S006","C004",700000);



/*
1	Write a SQL query to find student who go placed with highest package, along with the name of the company.						
*/
select student.stud_name, company.comp_name, placement.package from student
 inner join placement on student.ID = placement.S_ID
 inner join company on company.ID=placement.C_ID
 where placement.package = (select max(placement.package) from placement);

    

/*
2	HOD of ECE department wants to know placement details of all his department students, Write a SQL query for this scenario							
*/
SELECT student.stud_name as STUDENT, student.department as DEPARTMENT,
case when placement.S_ID is null then 'NO' else 'YES' end as PLACED, -- case statement to check for null
coalesce(company.comp_name,'-') as COMPANY, -- return first parameter if found null
coalesce(placement.package,'-') as PACKAGE  -- return first parameter if found null
FROM STUDENT
LEFT JOIN PLACEMENT ON STUDENT.ID = placement.S_ID
left join company on company.ID = PLACEMENT.C_ID
where student.department = "ECE";


/*
3	Write a SQL query to display total number of students each company has hired.						
*/ 
select distinct company.comp_name as COMPANY,
count(placement.C_ID) as `NO. OF STUDENTS`
 from company 
left join placement on company.ID=placement.C_ID
group by company.comp_name;
    
    
/*
4 - Write a SQL query which displays list of companies conducted interview in month of september					
*/
SELECT MONTHNAME(company.interview) as MONTH, company.comp_name as COMPANY from company
where month(company.interview)='09';

/*
5	Write a SQL query which displays list of companies which conducted interview till date
*/
select company.comp_name as COMPANY, company.interview as DATE from company order by date(curdate());
    
    
/*
6	Dean would like to know the students who got more than one placement offer, write a SQL query for this scenario								
*/
-- incomplete
select * from student
 inner join placement
 on student.ID = placement.S_ID
 inner join company
 on company.ID=placement.C_ID; 

/*
7 Accenture would like to shortlist candidates with CGPA > 7 and no need of student who already got placed, write SQL query that statisfies their given criteria								
*/
select student.stud_name as STUDENT,student.department as DEPARTMENT, student.cgpa as CGPA from student
 left join placement 
 on placement.S_ID = student.ID
 where placement.S_ID is null and student.cgpa > 7;

/* 
8	Yamuna decided that she will attend the interview of companies who's location name starts with 'B', write a query that gets the list of company she can attend								
*/
select company.comp_name as COMPANY, company.location as LOCATION from company
where company.location like 'B%';



