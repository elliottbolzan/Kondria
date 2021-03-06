import psycopg2
from PersonDAO import PersonDAO
from ReferralDTO import ReferralDTO
from Connection import Connection

class ReferralDAO():

    def createReferral(self, referral):
        companyId = PersonDAO().getCompanyForUser(referral.senderId)
        values = (referral.senderId, referral.recipientId, companyId, referral.status, referral.timestamp)
        sql = self.queryFromFile("create_referral.sql")
        conn = None
        try:
            conn = Connection()
            conn.cur.execute(sql, values)
            conn.commit()
            row = conn.cur.fetchone()
            referral.identifier, referral.company = row[0], row[1]
            conn.close()
        except (Exception, psycopg2.DatabaseError) as error:
            print(error)
            Referral = None
        finally: 
            if conn is not None:
                conn.close()
        return referral
    
    def updateReferral(self, referral):
        values = (referral.status, referral.timestamp, referral.identifier)
        sql = self.queryFromFile("update_referral.sql")
        conn = None
        try:
            conn = Connection()
            conn.cur.execute(sql, values)
            conn.commit()
            conn.close()
        except (Exception, psycopg2.DatabaseError) as error:
            print(error)
        finally:
            if conn is not None:
                conn.close()
        return referral

    def getReferrals(self, identifier):
        sql = self.queryFromFile("get_referral.sql")
        values = (identifier, identifier)
        conn = None
        referrals = []
        try:
            conn = Connection()
            conn.cur.execute(sql, values)
            result = conn.cur.fetchall()
            for row in result:
                referrals.append(ReferralDTO(*row))
        except (Exception, psycopg2.DatabaseError) as error:
            print(error) 
        finally:
            if conn is not None:
                conn.close()
        return referrals


    def queryFromFile(self, filename):
        fd = open("queries/" + filename, "r")
        sql = fd.read()
        fd.close()  
        return sql