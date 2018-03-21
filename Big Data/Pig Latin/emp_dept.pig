
Task 2
1.	
Smith = filter emp by ename == ‘SMITH’;
Smith_ed = foreach Smith generate hiredate;
dump Smith_ed;
	
2.	
Ford = filter emp by ename ==’FORD’;
Ford_job = foreach Ford generate job;
dump Ford_job;


3.	
hd = order emp by hiredate asc;
fhd= limit hd 1;
dump fhd;

4.	
emp_dept = join emp by deptno, dept by deptno;
dname_group = group emp_dept by dname;
num_emp = foreach dname_group generate group , COUNT($1);
dump num_emp;

5.	
emp_dept=join emp by deptno , dept by deptno;
loc_group=group emp_dept by loc;
num_emp=foreach loc_group generate group , COUNT($1);
dump num_emp;

6.	
emp_dept = join emp by deptno, dept by deptno;
dept_group = group emp_dept by loc;
avg_salary = foreach dept_group generate group, AVG(emp_dept.sal);
dump avg_salary;

7.	
emp_dept = group emp by deptno;
dep_max = foreach emp_dept generate FLATTEN(emp), MAX(emp.sal) as max;
emp_max = filter dep_max by sal==max;
dump emp_max;
	
8.	
emp1 = load 'ex_data/emp_dept/emp.csv' as (empno:int, ename:chararray, job:chararray, mgr:int, hiredate:datetime, sal:float, deptno: int);

emp2 = load 'ex_data/emp_dept/emp.csv' as (empno:int, ename:chararray, job:chararray, mgr:int, hiredate:datetime, sal:float, deptno: int);

mang = group emp by mgr;
mang_group= foreach mang generate group;
mang_empno = join mang_group by group, emp1 by empno;
mgr_group = group mang_empno by mgr;
mgr_mgr = foreach mgr_group generate group;
mgr_empno = join mgr_mgr by group, emp2 by empno;
mgr = foreach mgr_empno generate group, ename;
dump mgr;

9.	
hireyear = foreach emp generate GetYear(hiredate) as year;
year_group = group hireyear by year;
emp_count = foreach year_group generate COUNT(hireyear), group;
dump emp_count;

10.	
emp_salgrade = cross emp , salgrade;
emp_grade = filter emp_salgrade by losal <= sal and sal <= hisal;
grade = foreach emp_grade generate empno , ename , grade;
dump grade;

