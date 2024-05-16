# In this file you must implement your main query methods
# so they can be used by your database models to interact with your bot.

import os
from sre_constants import IN
import pymysql.cursors

#TODO: add the values for these database keys in your secrets on replit
db_host = os.environ["DB_HOST"]
db_username = os.environ["DB_USER"]
db_password = os.environ["DB_PASSWORD"]
db_name = os.environ["DB_NAME"]


class Database:

    # This method was already implemented for you
    def connect(self):
        """
        This method creates a connection with your database
        IMPORTANT: all the environment variables must be set correctly
                   before attempting to run this method. Otherwise, it
                   will throw an error message stating that the attempt
                   to connect to your database failed.
        """
        try:
            conn = pymysql.connect(host=db_host,
                                   port=3306,
                                   user=db_username,
                                   password=db_password,
                                   db=db_name,
                                   charset="utf8mb4",
                                   cursorclass=pymysql.cursors.DictCursor)
            print("Bot connected to database {}".format(db_name))
            return conn
        except ConnectionError as err:
            print(f"An error has occurred: {err.args[1]}")
            print("\n")

    #TODO: needs to implement the internal logic of all the main query operations
    def get_response(self,
                     query,
                     values=None,
                     fetch=False,
                     many_entities=False):
        """
        query: the SQL query with wildcards (if applicable) to avoid injection attacks
        values: the values passed in the query
        fetch: If set to True, then the method fetches data from the database (i.e with SELECT)
        many_entities: If set to True, the method can insert multiple entities at a time.
        """
        response = None
        connection = self.connect()
        cursor = connection.cursor()
        if values:
            if many_entities:
                cursor.executemany(query, values)
            else:
                cursor.execute(query, values)
        else:
            cursor.execute(query)
        connection.commit()
        # response = None
        connection.close()
        if fetch:
            response = cursor.fetchall()
        return response

    # the following methods were already implemented for you.
    @staticmethod
    def select(query, values=None, fetch=True):
        database = Database()
        return database.get_response(query, values=values, fetch=fetch)

    @staticmethod
    def insert(query, values=None, many_entities=False):
        database = Database()
        return database.get_response(query,
                                     values=values,
                                     many_entities=many_entities)

    @staticmethod
    def update(query, values=None):
        database = Database()
        return database.get_response(query, values=values)

    @staticmethod
    def delete(query, values=None):
        database = Database()
        return database.get_response(query, values=values)


class Query:
    GET_USER = """SELECT * FROM User WHERE email = %s"""
    GET_SITE = """SELECT * FROM Site WHERE site_identifier = %s"""
    GET_COUNTY = """SELECT county_id FROM County WHERE county_name = %s"""
    GET_SITE_IDENTIFIER = """SELECT site_identifier_id FROM Site_identifier WHERE site_identifier_name = %s"""
    INSERT_SITE_IDENTIFIER = """INSERT INTO Site_identifier (site_identifier_name) VALUES (%s)"""
    INSERT_SITE_RECORD = """INSERT INTO Site_record () VALUES ()"""
    GET_LATEST_SITE_RECORD = """SELECT MAX(site_record_id) FROM Site_record"""
    GET_SITE_RECORD = """SELECT * FROM Site_record WHERE site_record_id = %s"""
    CHECK_SITE_DOCS_FOR_SITE_RECORD = """SELECT site_record_id FROM site_record_has_site_docs WHERE site_record_has_site_docs.site_record_id = %s"""
    LINK_SITE_RECORD_TO_COUNTY = """INSERT INTO Site_record_has_county (site_record_id, county_id) VALUES (%s, %s)"""
    LINK_SITE_IDENTIFIER_TO_SITE_RECORD = """INSERT INTO Site_identifier_has_site_record (site_identifier_id, site_record_id) VALUES (%s, %s)"""
    GET_PERMISSIONS = """SELECT permissions_id FROM Permissions WHERE user_id = %s AND site_docs_id = %s"""
    UPDATE_PERMISSIONS = """UPDATE Permissions (permissions_level, permissions_role) VALUES (%s, %s) WHERE user_id = %s AND site_docs_id = %s"""
    INSERT_PERMISSIONS = """INSERT INTO Permissions (user_id, site_docs_id, permissions_level) VALUES (%s, %s, %s)"""
    UPDATE_ROLE = """UPDATE permissions (permissions_role, user_id) VALUES (%s, %s)"""
    INSERT_ROLE = """INSERT INTO permissions (permissions_role, user_id) VALUES (%s, %s)"""
    UPDATE_PRIVACY = """UPDATE Site_record (site_record_id, privacy_setting) VALUES (%s, %s)"""
    INSERT_PRIVACY = """INSERT INTO Site_record (site_record, privacy) VALUES (%s, %s)"""
    GET_CITATIONS = """SELECT si.site_identifier_name, c.citations_text FROM site_identifier si JOIN site_identifier_has_site_record sihsr ON sihsr.site_identifier_id = si.site_identifier_id JOIN site_record_has_citations srhc ON srhc.site_record_id = sihsr.site_record_id JOIN Citations c ON c.citations_id = srhc.citations_id WHERE si.site_identifier_name = %s"""
    CHECK_READINGS = """SELECT * FROM permissions JOIN site_docs ON site_docs.permissions_id = permissions.permissions_id JOIN site_docs.site_docs_id = site_record_has_site_docs.site_docs_id WHERE site_record_has_site_docs.site_record_id = %s AND permissions.user_id = %s"""
    UPDATE_READINGS = """UPDATE permissions (permissions_level) VALUES ("Read") WHERE permissions.permissions_id = %s"""
    ALLOW_USER_TO_READ = """INSERT INTO permissions (permissions_level, user_id, site_docs_id) VALUES ("Read", %s, %s)"""
    GET_PAST_REPORTS = """SELECT * FROM Site_record JOIN site_record ON site_identifier_has_site_record.site_record_id = site_record.sire_record_id JOIN site_identifier_has_site_record.site_identifier_id = site_identifier.site_identifier_id WHERE site_identifier.site_identifier_name LIKE %s"""
    GET_INFO_CENTER = """SELECT * FROM Info_center JOIN Info_center ON Info_center.info_center_id = county.info_center_id WHERE county.county_name = %s"""
    GET_REQUEST_APPROVAL = """SELECT permissions_id FROM Permissions WHERE user_id = %s AND site_docs_id = %s"""
    INSERT_GRAPHICS = """INSERT INTO photo (photo_path, photo_size, site_record_id) VALUES (%s, %s, %s)"""
    INSERT_SITE_DOCS = """INSERT INTO Site_docs (site_docs_name, site_docs_path, site_docs_type) VALUES (%s, %s, %s)"""
    GET_LATEST_SITE_DOCS = """SELECT MAX(site_docs_id) FROM Site_docs"""
    LINK_SITE_DOCS_TO_SITE_RECORD = """INSERT INTO Site_record_has_site_docs (site_record_id, site_docs_id) VALUES (%s, %s)"""
    SEARCH_SHAPEFILES = """SELECT * FROM shape_file WHERE shape_file_path LIKE %s"""
    SEARCH = """SELECT * FROM Site_record JOIN Site_identifier ON Site_identifier.site_identifier_id = Site_record.site_identifier_id JOIN County ON County.county_id = Site_record.county_id JOIN site_desc.site_record_id = site_record.site_record_id WHERE Site_record.site_record_id LIKE %s OR Site_identifier.site_identifier_name LIKE %s OR County.county_name LIKE %s OR site_desc.site_desc LIKE %s"""
    INSERT_CONTINUATION_DOCS = """INSERT INTO Continuation_docs (continuation_type, continuaion_path, site_record_id) VALUES (%s, %s, %s)"""
    # Done queries: 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
    # ALL QUERIES GO HERE
