MATCH (abrham:PERSON {name: "abrham wendmeneh"})-[:HAS_SKILL]->(skill)
RETURN skill.name


MATCH (abrham:PERSON {name: "abrham wendmeneh"})-[:COMPLETED_COURSE]->(course)
RETURN course.name

MATCH (abrham:PERSON {name: "abrham wendmeneh"})-[:HAS_SKILL]->(skill)

MATCH (abrham:PERSON {name: "abrham wendmeneh"})-[:ATTENDS]->(uni)
RETURN uni.name, uni.degree, uni.expected_graduation, uni.cgpa


MATCH (abrham:PERSON {name: "abrham wendmeneh"})-[:SPEAKS]->(language)
RETURN language.name

MATCH (abrham:PERSON {name: "abrham wendmeneh"})-[:INTERESTED_IN]->(interest)
RETURN interest.name

MATCH (abrham:PERSON {name: "abrham wendmeneh"})-[r]->(n)
RETURN type(r), n



// then create some other nodes and relationships
CREATE
(abel:PERSON {
    name: "abel kasahun",
    gender: "Female",
    email: "abel.kasahun@gmail.com",
    phone: "987654321",
    github: "abelGithub",
    linkedin: "abelLinkedin"
}),
(abel)-[:ATTENDS]->(uni),
(abel)-[:HAS_SKILL]->(python),
(abel)-[:HAS_SKILL]->(javascript),
(abel)-[:SPEAKS]->(english),
(abel)-[:INTERESTED_IN]->(ai),
(abel)-[:COMPLETED_COURSE]->(ml_course)


MATCH (abrham:PERSON {name: "abrham wendmeneh"}), (abel:PERSON {name: "abel kasahun"})
CREATE (abrham)-[:KNOWS]->(abel),
       (abel)-[:KNOWS]->(abrham)

CREATE
(project:PROJECT {
    name: "AI Research Project",
    description: "Research project on AI applications."
}),
(abrham)-[:WORKED_ON]->(project),
(abel)-[:WORKED_ON]->(project),
(project)-[:REQUIRES_SKILL]->(python),
(project)-[:REQUIRES_SKILL]->(ai)


MATCH (project:PROJECT)-[:REQUIRES_SKILL]->(skill)
RETURN project.name, skill.name

MATCH (project:PROJECT {name: "AI Research Project"})<-[:WORKED_ON]-(person)
RETURN person.name


// Add mentorship relationship

CREATE (abrham)-[:MENTORS]->(abel)

CREATE
(project2:PROJECT {
    name: "Mobile App Development",
    description: "Development of a cross-platform mobile application."
}),
(abrham)-[:WORKED_ON]->(project2),
(abel)-[:WORKED_ON]->(project2),
(project2)-[:REQUIRES_SKILL]->(dart),
(project2)-[:REQUIRES_SKILL]->(flutter),
(project2)-[:ASSOCIATED_WITH]->(uni)

MATCH (abrham:PERSON {name: "abrham wendmeneh"}), (abel:PERSON {name: "abel kasahun"}), (ai:INTEREST {name: "AI"})
CREATE (abrham)-[:SHARES_INTEREST]->(abel)-[:INTERESTED_IN]->(ai)

CREATE
(company1:COMPANY {name: "1888", role: "Software Engineer", duration: "3 months"}),
(company2:COMPANY {name: "icog", role: "Intern", duration: "1 month"}),

(john)-[:WORKED_AT]->(company1),
(jane)-[:WORKED_AT]->(company2),

(company1)-[:USES_SKILL]->(python),
(company1)-[:USES_SKILL]->(javascript),
(company2)-[:USES_SKILL]->(react),
(company2)-[:USES_SKILL]->(node)


MATCH (project:PROJECT)-[:REQUIRES_SKILL]->(skill {name: "Python"})
RETURN project.name

MATCH (mentor:PERSON)-[:MENTORS]->(mentee:PERSON)
RETURN mentor.name AS Mentor, mentee.name AS Mentee

MATCH (p1:PERSON)-[:SHARES_INTEREST]->(p2:PERSON), (p1)-[:WORKED_ON]->(project), (p2)-[:WORKED_ON]->(project)
RETURN p1.name AS Person1, p2.name AS Person2, project.name AS SharedProject

MATCH (uni:Addis_Ababa_University {name: "Addis Ababa University"})<-[:ASSOCIATED_WITH]-(project)-[:REQUIRES_SKILL]->(skill)
RETURN project.name, skill.name


MATCH (company:COMPANY)-[:USES_SKILL]->(skill)
RETURN company.name, skill.name


MATCH (person:PERSON)-[:SPEAKS]->(language {name: "English"}), (person)-[:WORKED_AT]->(company {name: "1888"})
RETURN person.name, company.name

MATCH (interest:INTEREST {name: "AI"})<-[:INTERESTED_IN]-(person)-[:WORKED_ON]->(project)
RETURN person.name, project.name


MATCH (p1:PERSON)-[:SHARES_INTEREST]->(p2:PERSON), (p1)-[:ATTENDS]->(uni), (p2)-[:ATTENDS]->(uni)
RETURN p1.name AS Person1, p2.name AS Person2, uni.name AS University


MATCH (person:PERSON)-[:WORKED_AT]->(company)-[:USES_SKILL]->(skill)
RETURN person.name, company.name, skill.name
