from database import *

# class UserModel:

#   def __init__(self, email):
#     self.email = email
#     self.id = None
#     self.name = None

#   @staticmethod
#   def get(email):
#     db = Database()
#     query = Query.GET_USER
#     value = (email)
#     my_user_data = db.get_response(query, values=value, fetch=True)
#     my_user_object = UserModel(email)
#     for user in my_user_data:
#       my_user_object.user_id = user['user_id']
#       my_user_object.name = user['name']
#     return my_user_object


class NewSite:

  def __init__(self, site_identifier, county, description):
    self.site_identifier = site_identifier
    self.county = county
    self.description = description
    self.id = None

    @staticmethod
    def insert(site_identifier, county, description):
      db = Database()
      query = Query.GET_COUNTY
      value = (county)
      my_county_id = db.get_response(query, values=value, fetch=True)
      if my_county_id == None:
        print("County not found")
        return False
      else:
        query = Query.GET_SITE_IDENTIFIER
        value = (site_identifier)
        my_site_identifier = db.get_response(query,
                                             values=value,
                                             many_entities=True)
        if my_site_identifier == None:
          query = Query.INSERT_SITE_IDENTIFIER
          value = (site_identifier)
          db.insert(query, values=value)
          query = Query.GET_SITE_IDENTIFIER
          value = (site_identifier)
          my_site_identifier = db.get_response(query,
                                               values=value,
                                               many_entities=True)
        query = Query.INSERT_SITE_RECORD
        value = ()
        db.insert(query, values=value)
        query = Query.GET_LATEST_SITE_RECORD
        my_site_record = db.get_response(query,
                                         values=value,
                                         many_entities=True)
        query = Query.LINK_SITE_RECORD_TO_COUNTY
        value = (my_site_record, my_county_id)
        db.insert(query, values=value)
        query = Query.LINK_SITE_IDENTIFIER_TO_SITE_RECORD
        value = (my_site_identifier, my_site_record)
        db.insert(query, values=value)
        return True


class NewPermission:

  def __init__(self, user_id, site_record_id, permissions_level,
               permissions_role):
    self.user_id = user_id
    self.site_record_id = site_record_id
    self.permissions_level = permissions_level
    self.permissions_role = permissions_role
    self.id = None

    @staticmethod
    def update(user_id, site_record, permissions_level, permissions_role):
      db = Database()
      query = Query.GET_USER
      value = (user_id)
      my_user_id = db.get_response(query, values=value, fetch=True)
      if my_user_id == None:
        print("User not found")
        return False
      else:
        query = Query.GET_SITE_RECORD
        value = (site_record_id)
        my_site_record = db.get_response(query, values=value, fetch=True)
        if my_site_record == None:
          print("Site record not found")
          return False
        else:
          query = Query.CHECK_SITE_DOCS_FOR_SITE_RECORD
          value = (site_record_id)
          my_site_docs = db.get_response(query, values=value, fetch=True)
          if my_site_docs == None:
            print("Site docs not found")
            return False
          else:
            query = Query.UPDATE_PERMISSIONS
            value = (permissions_level, permissions_role, my_user_id,
                     my_site_record)
            db.update(query, values=value)
            return True


class NewRole:

  def __init__(self, user_id, role):
    self.user_id = user_id
    self.role = role
    self.id = None

    @staticmethod
    def update(user_id, role):
      db = Database()
      try:
        query = Query.UPDATE_ROLE
        value = (role, user_id)
        db.update(query, values=value)
        return True
      except Exception as e:
        print("Could not update role: ", e)
        try:
          query = Query.INSERT_ROLE
          value = (role, user_id)
          db.insert(query, values=value)
          return True
        except Exception as e:
          print("Could not insert role: ", e)
          return False


class Privacy:

  def __init__(self, site_record_id, privacy_setting):
    self.site_record_id = site_record_id
    self.privacy_setting = privacy_setting
    self.id = None

    @staticmethod
    def update(site_record_id, privacy_setting):
      db = Database()
      query = Query.GET_SITE_RECORD
      value = (site_record_id)
      my_site_record = db.get_response(query, values=value, fetch=True)
      if my_site_record == None:
        print("Site record not found")
        return False
      try:
        query = Query.UPDATE_PRIVACY
        value = (site_record_id, privacy_setting)
        db.update(query, values=value)
        return True
      except Exception as e:
        print("Could not update privacy: ", e)
        try:
          query = Query.INSERT_PRIVACY
          value = (site_record_id, privacy_setting)
          db.insert(query, values=value)
          return True
        except Exception as e:
          print("Could not insert privacy: ", e)
          return False


class AllowDocsUpdates:

  def __init__(self, user_id, site_docs_id):
    self.user_id = user_id
    self.site_docs_id = site_docs_id
    self.id = None

  @staticmethod
  def update(user_id, site_docs_id):
    db = Database()
    query = Query.GET_PERMISSIONS
    value = (user_id, site_docs_id)
    my_permissions = db.get_response(query, values=value, fetch=True)
    if my_permissions == None:
      query = Query.INSERT_PERMISSIONS
      value = (user_id, site_docs_id, "Read/Write")
      db.insert(query, values=value)
      return True
    else:
      query = Query.UPDATE_PERMISSIONS
      value = ("Read/Write", my_permissions)
      db.update(query, values=value)
      return True


class GetCitations:

  def __init__(self, site_identifier):
    self.site_identifier = site_identifier
    self.id = None
    self.citations = None

  @staticmethod
  def get(site_identifier):
    db = Database()
    query = Query.GET_CITATIONS
    value = (site_identifier)
    my_site_data = db.get_response(query, values=value, fetch=True)
    if my_site_data == None:
      print("Site not found")
      return False
    my_site_object = GetCitations(site_identifier)
    for site in my_site_data:
      my_site_object.site_identifier = site['site_identifier']
      my_site_object.citations = site['citations']
    return my_site_object


class AvailableReading:

  def __init__(self, site_record_id, user_id):
    self.site_record_id = site_record_id
    self.user_id = user_id
    self.id = None

    @staticmethod
    def update(site_record_id, user_id):
      db = Database()
      query = Query.CHECK_READINGS
      value = (site_record_id, user_id)
      my_reading_permissions = db.get_response(query, values=value, fetch=True)
      if my_reading_permissions == "None":
        try:
          query = Query.UPDATE_READINGS
          value = (site_record_id, user_id)
          db.update(query, values=value)
          return True
        except Exception as e:
          print("Could not update readings: ", e)
          return False
      elif my_reading_permissions == None:
        try:
          query = Query.ALLOW_USER_TO_READ
          value = (site_record_id, user_id)
          db.insert(query, values=value)
          return True
        except Exception as e:
          print("Could not allow user to read: ", e)
          return False


class GetPastReports:

  def __init__(self, site_search):
    self.site_search = site_search
    self.id = None
    self.past_reports = None

  @staticmethod
  def get(site_search):
    db = Database()
    query = Query.GET_PAST_REPORTS
    value = (site_search)
    my_past_reports = db.get_response(query, values=value, fetch=True)
    if my_past_reports == None:
      print("Site not found")
      return False
    my_past_reports_object = PastReports(site_search)
    return my_past_reports_object


class GetInfoCenter:

  def __init__(self, county_name):
    self.county_name = county_name
    self.id = None
    self.info_center = None

  @staticmethod
  def get(county_name):
    db = Database()
    query = Query.GET_INFO_CENTER
    value = (county_name)
    my_info_center = db.get_response(query, values=value, fetch=True)
    if my_info_center is None:
      print("Info center not found")
      return False
    else:
      my_info_object = GetInfoCenter(my_info_center)
      for info_obj in my_info_center:
        my_info_object.county_name = info_obj['county_name']
        my_info_object.info_center = info_obj['info_center']
      return my_info_object


class ApproveRequest:

  def __init__(self, site_record_id, user_id):
    self.site_record_id = site_record_id
    self.user_id = user_id
    self.id = None

  @staticmethod
  def get(site_record_id, user_id):
    db = Database()
    query = Query.CHECK_SITE_DOCS_FOR_SITE_RECORD
    value = (site_record_id)
    my_site_docs = db.get_response(query, values=value, fetch=True)
    if my_site_docs == None:
      print("Site docs not found")
      return False
    else:
      query = Query.GET_REQUEST_APPROVAL
      value = (user_id, my_site_docs)
      my_request = db.get_response(query, values=value, fetch=True)
      if my_request == "None":
        print("User not authorized for site record" + site_record_id)
        return False
      elif my_request == None:
        print("Request not found")
        return False
      else:
        print("User authorized for site record" + site_record_id)
        return True


class AddGraphics:

  def __init__(self, site_record_id, photo_path, photo_size):
    self.site_record_id = site_record_id
    self.photo_path = photo_path
    self.photo_size = photo_size
    self.id = None

  @staticmethod
  def insert(site_record_id, photo_path, photo_size):
    db = Database()
    query = Query.INSERT_GRAPHICS
    value = (photo_path, photo_size, site_record_id)
    db.insert(query, values=value)
    return True


class AddSiteDocs:

  def __init__(self, site_record_id, site_docs_name, site_docs_path,
               site_docs_type):
    self.site_record_id = site_record_id
    self.site_docs_name = site_docs_name
    self.site_docs_path = site_docs_path
    self.site_docs_type = site_docs_type
    self.id = None

  @staticmethod
  def insert(site_record_id, site_docs_name, site_docs_path, site_docs_type):
    db = Database()
    query = Query.INSERT_SITE_DOCS
    value = (site_docs_name, site_docs_path, site_docs_type)
    db.insert(query, values=value)
    query = Query.GET_LATEST_SITE_DOCS
    my_site_docs = db.get_response(query, values=value, fetch=True)
    query = Query.LINK_SITE_DOCS_TO_SITE_RECORD
    value = (site_record_id, my_site_docs)
    db.insert(query, values=value)
    return True


class SearchShapefiles:

  def __init__(self, search_shapefiles):
    self.search_shapefiles = search_shapefiles
    self.id = None
    self.shapefiles = None

  @staticmethod
  def get(search_shapefiles):
    db = Database()
    query = Query.SEARCH_SHAPEFILES
    value = (search_shapefiles)
    my_shapefiles = db.get_response(query, values=value, fetch=True)
    if my_shapefiles == None:
      print("Shapefiles not found")
      return False
    else:
      my_shapefiles_object = SearchShapefiles(search_shapefiles)
      for shapefile in my_shapefiles:
        my_shapefiles_object.search_shapefiles = shapefile['search_shapefiles']
        my_shapefiles_object.shapefiles = shapefile['shapefiles']
      return my_shapefiles_object
      


class Search:

  def __init__(self, search_term):
    self.search_term = search_term
    self.id = None
    self.search_results = None

  @staticmethod
  def get(search_term):
    db = Database()
    query = Query.SEARCH
    value = (search_term)
    my_search_results = db.get_response(query, values=value, fetch=True)
    if my_search_results == None:
      print("Search term not found")
      return False
    else:
      my_search_object = Search(search_term)
      for search_obj in my_search_results:
        my_search_object.search_term = search_obj['search_term']
        my_search_object.search_results = search_obj['search_results']
      return my_search_object


class AddContinuationDocs:

  def __init__(self, site_record_id, continuation_type, continuation_path):
    self.site_record_id = site_record_id
    self.continuation_type = continuation_type
    self.continuation_path = continuation_path
    self.id = None

  @staticmethod
  def insert(site_record_id, continuation_type, continuation_path):
    db = Database()
    query = Query.INSERT_CONTINUATION_DOCS
    value = (continuation_type, continuation_path, site_record_id)
    db.insert(query, values=value)
    return True
