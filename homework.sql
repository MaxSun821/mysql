1、取得每个部门最高薪水的人员名称

第一步：取得每个部门最高薪水
select deptno, max(sal+ifnull(comm, 0)) as maxSal from emp group by deptno;

+--------+---------+
| deptno | maxSal  |
+--------+---------+
|     10 | 5000.00 |
|     20 | 3000.00 |
|     30 | 2850.00 |
+--------+---------+

第二步：检索薪水和部门相同人的名字
select
    e.ename, t.*
from
    (select deptno, max(sal+ifnull(comm, 0)) as maxSal from emp group by deptno)t
join
    emp e
on
    t.deptno = e.deptno and t.maxSal = (e.sal+ifnull(e.comm, 0));