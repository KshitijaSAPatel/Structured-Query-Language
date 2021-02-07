-- Find the names of all students who are friends with someone named Gabriel.

select name 
from Highschooler
where ID in (select ID2 from Highschooler h, Friend f where f.ID1 = h.ID and h.name = "Gabriel");

-- For every student who likes someone 2 or more grades younger than themselves, 
-- return that student's name and grade, and the name and grade of the student they like.

select h1.name, h1.grade, h2.name, h2.grade
from Highschooler h1 inner join Likes on Likes.ID1 = h1.ID 
	inner join Highschooler h2 on Likes.ID2 = h2.ID
where (h1.grade - h2.grade) > 2;

-- For every pair of students who both like each other, return the name and grade of both students. 
-- Include each pair only once, with the two names in alphabetical order.

select h1.name, h1.grade, h2.name, h2.grade
from Highschooler h1, Highschooler h2, Likes l1, Likes l2
where (h1.ID = l1.ID1 and h2.ID = l1.ID2)
	and (h2.ID = l2.ID1 and h1.ID = l2.ID2)
    and h1.name < h2.name
order by h1.name, h2.name; 

-- Find all students who do not appear in the Likes table (as a student who likes or is liked) 
-- and return their names and grades. Sort by grade, then by name within each grade.

select name, grade
from Highschooler
where ID not in (select ID1 from Likes
	union 
    select ID2 from Likes)
order by grade, name;

-- For every situation where student A likes student B, but we have no information about whom B likes 
-- (that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades.

select h1.name, h1.grade, h2.name, h2.grade
from Highschooler h1 inner join Likes on Likes.ID1 = h1.ID 
	inner join Highschooler h2 on Likes.ID2 = h2.ID
where h2.ID not in (select ID1 from Likes); 

-- Find names and grades of students who only have friends in the same grade. Return the result sorted by grade, 
-- then by name within each grade.

select distinct name, grade
from Highschooler inner join Friend on Friend.ID1 = Highschooler.ID
where ID not in 
(select distinct h1.ID
	from Highschooler h1 inner join Friend on Friend.ID1 = h1.ID inner join Highschooler h2 on Friend.ID2 = h2.ID
	where h2.grade != h1.grade)
order by grade, name; 

-- For each student A who likes a student B where the two are not friends, find if they have a friend C in common 
-- (who can introduce them!). For all such trios, return the name and grade of A, B, and C.

select distinct h1.name, h1.grade, h2.name, h2.grade, h3.name, h3.grade
from Highschooler h1, Highschooler h2, Highschooler h3, Likes l, Friend f1, Friend f2
where (h1.ID = l.ID1 and h2.ID = l.ID2) 
	and (h1.ID = f1.ID1 and h3.ID = f1.ID2) 
    and (h2.ID = f2.ID1 and h3.ID = f2.ID2) 
    and h2.ID not in (
		select ID2
        from Friend
        where ID1 = h1.ID
	);