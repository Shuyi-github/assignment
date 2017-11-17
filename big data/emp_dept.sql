Task 2

1. select hiredate from emp where ename=SMITH;

2. select job from emp where ename=FORD;

3. select * from emp order by hiredatei asc limit 1;

4. select dname, COUNT(empno) from emp,dept where emp.deptno=dept.deptno group by deptno;

5. select loc, COUNT(empno) from emp, dept where emp.deptno=dept.deptno group by loc;

5. select loc, AVG(sal) from emp, dept where emp.deptno=dept.deptno group by loc;

7. select * from emp JOIN (select empno, MAX(sal) from emp group by deptno) as empmax where emp.empno=empmax.empno;

8. select A.* from (select B.mgr as m1 from ((select mgr from emp C group by mgr) as mgr1 join emp B where mgr1.mgr=B.empno) as mgr1 group by B.mgr) join emp A where mgr1.m1=A.empno;

9. select COUNT(empno), YEAR(hiredate) from emp group by YEAR(hiredate);

10. select emp.*, salgrade.grade from emp cross join salgrade where losal < sal and sal <= hisal;
