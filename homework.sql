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

第二步：将上面的表作为临时表进行检索
select
    e.ename, t.*
from
    (select deptno, max(sal+ifnull(comm, 0)) as maxSal from emp group by deptno)t
join
    emp e
on
    t.deptno = e.deptno and t.maxSal = (e.sal+ifnull(e.comm, 0));
+-------+--------+---------+
| ename | deptno | maxSal  |
+-------+--------+---------+
| BLAKE |     30 | 2850.00 |
| SCOTT |     20 | 3000.00 |
| KING  |     10 | 5000.00 |
| FORD  |     20 | 3000.00 |
+-------+--------+---------+

2、哪些人的薪水在部门的平均薪水之上
第一步：找出个部门平均薪水
select deptno, avg(sal) as avgSal from emp group by deptno;
+--------+-------------+
| deptno | avgSal      |
+--------+-------------+
|     10 | 2916.666667 |
|     20 | 2175.000000 |
|     30 | 1566.666667 |
+--------+-------------+
第二步：将上面当做一个临时表，找到比平均薪水多的，并且部门编号相同
select
    e.ename, e.sal
from
    emp e
join
    (select deptno, avg(sal) as avgSal from emp group by deptno)t
on
    t.deptno = e.deptno and e.sal > avgSal;
+-------+---------+
| ename | sal     |
+-------+---------+
| ALLEN | 1600.00 |
| JONES | 2975.00 |
| BLAKE | 2850.00 |
| SCOTT | 3000.00 |
| KING  | 5000.00 |
| FORD  | 3000.00 |
+-------+---------+

3、取得部门中（所有人的）平均的薪水等级
select e.deptno, avg(s.grade) from emp e join salgrade s on e.sal between s.losal and s.hisal group by deptno;
+--------+--------------+
| deptno | avg(s.grade) |
+--------+--------------+
|     10 |       3.6667 |
|     20 |       2.8000 |
|     30 |       2.5000 |
+--------+--------------+

4、不准用组函数（Max），取得最高薪水
使用排序
select sal from emp order by sal desc limit 0, 1;
+---------+
| sal     |
+---------+
| 5000.00 |
+---------+

5、取得平均薪水最高的部门的部门编号
select deptno from emp group by deptno order by avg(sal) desc limit 0,1;
+--------+
| deptno |
+--------+
|     10 |
+--------+

6、取得平均薪水最高的部门的部门名称
第一步：求出平均薪水最高的部门
select deptno from emp group by deptno order by avg(sal) desc limit 0,1;
+--------+
| deptno |
+--------+
|     10 |
+--------+
第二步：将上表和部门表联合搜索
select
    d.dname
from
    dept d
join
    (select deptno from emp group by deptno order by avg(sal) desc limit 0,1)t
on
    t.deptno = d.deptno;
+------------+
| dname      |
+------------+
| ACCOUNTING |
+------------+

7、求平均薪水的等级最低的部门的部门名称
第一步：取得部门平均薪水等级
select e.deptno, avg(s.grade) from emp e join salgrade s on e.sal between s.losal and s.hisal group by deptno order by avg(s.grade) asc limit 0, 1;
第二步：将上表和部门表联合搜索
select 
    d.dname
from
    dept d
join
    (select e.deptno, avg(s.grade) from emp e join salgrade s on e.sal between s.losal and s.hisal group by deptno order by avg(s.grade) asc limit 0, 1)t
on
    d.deptno = t.deptno;
+-------+
| dname |
+-------+
| SALES |
+-------+

8、取得比普通员工（员工代码没有在mgr字段上出现的）的最高薪水还要搞的领导人姓名
select a.ename, a.sal from emp a join emp b on a.mgr <> b.empno;


9、取得薪水最高的前五名员工
select ename, sal from emp order by sal desc limit 0, 5;
+-------+---------+
| ename | sal     |
+-------+---------+
| KING  | 5000.00 |
| FORD  | 3000.00 |
| SCOTT | 3000.00 |
| JONES | 2975.00 |
| BLAKE | 2850.00 |
+-------+---------+

10、取得薪水最高的第六到第十名员工
select ename, sal from emp order by sal desc, ename limit 5, 5;
+--------+---------+
| ename  | sal     |
+--------+---------+
| CLARK  | 2450.00 |
| ALLEN  | 1600.00 |
| TURNER | 1500.00 |
| MILLER | 1300.00 |
| MARTIN | 1250.00 |
+--------+---------+

11、取得最后入职的5名员工
select ename, hiredate from emp order by hiredate desc, ename limit 0, 5;
+--------+------------+
| ename  | hiredate   |
+--------+------------+
| ADAMS  | 1987-05-23 |
| SCOTT  | 1987-04-19 |
| MILLER | 1982-01-23 |
| FORD   | 1981-12-03 |
| JAMES  | 1981-12-03 |
+--------+------------+

12、取得每个薪水等级有多少员工
select
    s.grade, e.ename
from
    emp e
join
    salgrade s
on
    e.sal between s.losal and s.hisal;
+-------+--------+
| grade | ename  |
+-------+--------+
|     1 | SMITH  |
|     3 | ALLEN  |
|     2 | WARD   |
|     4 | JONES  |
|     2 | MARTIN |
|     4 | BLAKE  |
|     4 | CLARK  |
|     4 | SCOTT  |
|     5 | KING   |
|     3 | TURNER |
|     1 | ADAMS  |
|     1 | JAMES  |
|     4 | FORD   |
|     2 | MILLER |
+-------+--------+
select
    t.grade, count(*)
from
    (select s.grade, e.ename from emp e join salgrade s on e.sal between s.losal and s.hisal)t
group by
    t.grade;
+-------+----------+
| grade | count(*) |
+-------+----------+
|     1 |        3 |
|     2 |        3 |
|     3 |        2 |
|     4 |        5 |
|     5 |        1 |
+-------+----------+

13、面试题
S表
+------+---------+
| SNO  | SNAME   |
+------+---------+
| 1    | 学生1   |
| 2    | 学生2   |
| 3    | 学生3   |
| 4    | 学生4   |
+------+---------+
C表
+------+--------+----------+
| CNO  | CNAME  | CTEACHER |
+------+--------+----------+
| 1    | 语文   | 张       |
| 2    | 政治   | 王       |
| 3    | 英语   | 李       |
| 4    | 数学   | 赵       |
| 5    | 物理   | 黎明     |
+------+--------+----------+
SC表
+------+------+---------+
| SNO  | CNO  | SCGRADE |
+------+------+---------+
| 1    | 1    | 40      |
| 1    | 2    | 30      |
| 1    | 3    | 20      |
| 1    | 4    | 80      |
| 1    | 5    | 60      |
| 2    | 1    | 60      |
| 2    | 2    | 60      |
| 2    | 3    | 60      |
| 2    | 4    | 60      |
| 2    | 5    | 40      |
| 3    | 1    | 60      |
| 3    | 3    | 80      |
+------+------+---------+


(1)找出没选过“黎明”老师的所有学生姓名。
第一步：找出黎明老师的教师号。
select cno from C where CTEACHER = '黎明';
+------+
| cno  |
+------+
| 5    |
+------+
第二步：用上表和SC表联合找到选了黎明老师cno的学生编号。
select sno from SC where cno = (select cno from C where CTEACHER = '黎明');
+------+
| sno  |
+------+
| 1    |
| 2    |
+------+
第三步：用上表和C表联合找到sno不是1和2的学生的sname

(2)列出2门以上（含2门）不及格学生姓名及平均成绩。

(3)既学过1号课程又学过2号课所有学生的姓名。
select stu.sname from S stu join SC stuc on stu.sno = stuc.sno and stuc.cno in(1,2);

