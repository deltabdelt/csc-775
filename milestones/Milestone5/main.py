"""
The code below is just representative of the implementation of a Bot. 
However, this code was not meant to be compiled as it. It is the responsability 
of all the students to modifify this code such that it can fit the 
requirements for this assignments.
"""

import discord
import os
from discord.ext import commands
from models import *
from database import Database

#TODO:  add your Discord Token as a value to your secrets on replit using the DISCORD_TOKEN key
TOKEN = os.environ["DISCORD_TOKEN"]

intents = discord.Intents.all()

bot = commands.Bot(command_prefix='!', intents=discord.Intents.all())


@bot.command(
    name="test",
    description="write your database business requirement for this command here"
)
async def _test(ctx, arg1):
  # testModel = TestModel(ctx, arg1)
  # response = testModel.response()
  my_db_instance = Database()
  if my_db_instance.connect():
    response = f'Hi {arg1} from your bot. The bot is connected to the database'
  else:
    response = f'The bot is not connected to the database'
  await ctx.send(response)


# TODO: complete the following tasks:
#       (1) Replace the commands' names with your own commands
#       (2) Write the description of your business requirement in the description parameter
#       (3) Implement your commands' methods.


@bot.command(name="getuser",
             description="database business requirement #0 here")
async def _command0(ctx, *args):
  user = N.get(args[0])
  response = f'The user {user.name} with email {args[0]} is in the database'
  await ctx.send(response)
  # await ctx.send("This method is not implemented yet")


@bot.command(
    name="newrecord",
    description=
    "DBR #1: New site record with site identifier, county, site description")
async def _command1(ctx, *args):
  site_identifier = args[0]
  county = args[1]
  description = args[2]
  new_site = N.insert(site_identifier, county, description)
  response = f'Successfully added: {new_site}'
  await ctx.send(response)


  
@bot.command(
    name="permissions",
    description=
    "DBR #2: Creation of unique user profiles for information centers and qualified professionals; customized access settings allow each profile access to particular site records"
)
async def _command2(ctx, *args):
  user_id = args[0]
  site_record_id = args[1]
  permissions_level = args[2]
  set_permissions = N.update(user_id, site_record_id, permissions_level)
  response = f'Successfully added: {set_permissions}'
  await ctx.send(response)



@bot.command(
    name="role",
    description=
    "DBR #3: Specify site managers, site recorders, site owners, and site workers."
)
async def _command3(ctx, *args):
  user = args[0]
  role = args[1]
  set_role = N.update(user, role)
  response = f'Successfully added: {set_role}'
  await ctx.send(response)



@bot.command(
    name="privacy",
    description=
    "DBR #4: Assign a privacy level to each site, to protect confidentiality and protect sites from looters while also identifying information available for publication."
)
async def _command4(ctx, *args):
  site_record = args[0]
  privacy = args[1]
  set_privacy = N.update(site_record, privacy)
  response = f'Successfully updated: {set_privacy}'
  await ctx.send(response)



@bot.command(
    name="allow_updates",
    description=
    "DBR #5: Provide users with access privileges the ability to update site documents."
)
async def _command5(ctx, *args):
  user_id = args[0]
  site_docs_id = args[1]
  allow_doc_updates = N.update(user_id, site_docs_id)
  response = f'User {args[0]} has been given access to update site document {args[1]}.'
  await ctx.send(response)


  
@bot.command(
    name="citations",
    description=
    "DBR #6: Allow users to see peer-reviewed academic journal article citations associated with the site."
)
async def _command6(ctx, *args):
  site = N.get(args[0])
  response = f'The site {args[0]} is associated with the following citations: {site.citations}'
  await ctx.send(response)



@bot.command(
    name="readings",
    description=
    "DBR #7: Allow the site owner or manager to make background readings and schematics available to all site workers."
)
async def _command7(ctx, *args):
  site_record = args[0]
  user = args[1]
  set_available = N.update(site_record, user)
  response = f'Successfully made available:             {set_available}'
  await ctx.send(response)


@bot.command(
    name="past_reports",
    description=
    "DBR #8: Track changes across time at an archaeological site by linking site records from different times at the same site."
)
async def _command8(ctx, *args):
  site_search = args[0]
  get_past_reports = GetPastReports(site_search)
  response = f'The following site records hare associated with the site: {get_past_reports}'
  await ctx.send(response)


@bot.command(
    name="which_info_center",
    description=
    "DBR #9: Tie information centers to all sites within the counties that they service."
)
async def _command9(ctx, *args):
  county = args[0]
  get_info_center = GetInfoCenter(county)
  response = f'The info center {get_info_center} is associated with the county: {args[0]}'
  await ctx.send(response)


@bot.command(
    name="approve_request",
    description=
    "DBR #10: Enable automatic importing of records from an information center in response to a records request from a qualified professional."
)
async def _command10(ctx, *args):
  site_record_id = args[0]
  user_id = args[1]
  approve_request = ApproveRequest(site_record_id, user_id)
  response = f'Successfully approved request: {approve_request}'



@bot.command(
    name="add_graphics",
    description="DBR #11: Add photos and maps with labels to a site record.")
async def _command11(ctx, *args):
  site_record_id = args[0]
  photo_path = args[1]
  photo_size = args[2]
  add_graphics = AddGraphics(site_record_id, photo_path, photo_size)
  response = f'Successfully added: {add_graphics}'
  await ctx.send(response)
  

@bot.command(
    name="add_site_docs",
    description=
    "DBR #12: Provide a section for owners and managers to upload and access important site procedure forms, including site methodology, safety protocols, and final report."
)
async def _command12(ctx, *args):
  site_record_id = args[0]
  site_docs_name = args[1]
  site_docs_path = args[2]
  site_docs_type = args[3]
  add_site_docs = AddSiteDocs(site_record_id, site_docs_name, site_docs_path, site_docs_type)
  await ctx.send("Succesfully added site docs")


@bot.command(
    name="search_shapefiles",
    description=
    "DBR #13: Incorporate a geophysical search function that allows users to see all site records within the boundaries of a given USGS map."
)
async def _command13(ctx, *args):
  search_shapefiles = SearchShapefiles(args[0])
  response = f'The following shapefiles are associated with the site: {search_shapefiles}'
  await ctx.send(response)


@bot.command(
    name="search",
    description=
    "DBR #14: Enable search by any element of the site record, including geographic location, shape maps, and the open-ended site description field."
)
async def _command14(ctx, *args):
  search_term = Search(args[0])
  response = f'The search term {args[0]} returned the following results: {search_term}'
  await ctx.send(response)


@bot.command(
    name="submit_field_docs",
    description=
    "DBR #15: Allow archaeologists working on a given site to submit unit records, supplementary unit photographs, and unit continuation sheets associated with that site"
)
async def _command15(ctx, *args):
  site_record_id = args[0]
  continuation_type = args[1]
  continuation_path = args[2]
  submit_field_docs = SubmitFieldDocs(site_record_id, continuation_type, continuation_path)
  await ctx.send("Method completed")


bot.run(TOKEN)
