--update a user's company, education, experience, university

--add row to University table if university not already in it
INSERT INTO University (id, name)
SELECT '20000000', 'UNC'
WHERE NOT EXISTS (SELECT name FROM University WHERE name='UNC');

--add row to Company table if company not already in it
INSERT INTO Company (id, name)
SELECT '20000000', 'Apple'
WHERE NOT EXISTS (SELECT name FROM Company WHERE name='Apple');

--add a new education
INSERT INTO Education VALUES ('20000000', '20000000', '20000000', 'BA', TIMESTAMP '2011-05-16 15:36:38');

--update an existing education
UPDATE Education
SET university='111', degree_type='BS', startdate=TIMESTAMP '2011-05-16 15:36:38', enddate=TIMESTAMP '2016-07-23 00:00:00'
WHERE id = '1' and person='1';

--add a new job experience
INSERT INTO Experience VALUES ('20000000', '20000000', '12000000', 'software engineer', TIMESTAMP '2011-05-16 15:36:38');

--update an existing job experience
UPDATE Experience
SET company='1', position='Product Manager', startdate=TIMESTAMP '2011-05-16 15:36:38', enddate=TIMESTAMP '2016-07-23 00:00:00'
WHERE id = '1' and person='1';