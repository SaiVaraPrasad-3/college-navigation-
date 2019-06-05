var db_host = "http://172.20.10.3:3000";
// var db_host = "http://192.168.0.6:3000";

//to get images

var GET_USER_IMAGES = "$db_host/images/users_images/";
var GET_BLOCK_IMAGES = "$db_host/images/blocks_images/";
var GET_STRUCTURE_IMAGES = "$db_host/images/classes_images/";

// users
var URL_USER_SIGNUP =
    "$db_host/mobileUsers/signup"; //create user and signup(POST)
var URL_USER_LOGIN = "$db_host/mobileUsers/login"; //login user (POST)
var URL_CHECK_EMAIL = "$db_host/mobileUsers/email"; //check email (POST)
var URL_CHECK_USERNAME = "$db_host/mobileUsers/username"; //check email (POST)
var URL_USER_UPDATE =
    "$db_host/mobileUsers/update"; //update user (:id) gives id
var URL_USER_USER_ID =
    "$db_host/mobileUsers/userprofile"; //get userid (:id) gives id
var URL_USER_UPLOAD_IMAGE =
    "$db_host/mobileUsers/changeImage"; //upload image (:id) gives id

// blocks
var URL_BLOCKS_GET_ALL = "$db_host/mobileBlocks/"; //get all blocks
var URL_BLOCKS_GET_INDIVIDUAL =
    "$db_host/mobileBlocks/"; //get individual blocks (:id) gives block id

// structure
var URL_STRUCTURE_GET_ALL = "$db_host/mobileClasses/"; //get all classes
var URL_STRUCTURE_GET_INDIVIDUAL =
    "$db_host/mobileClasses/individual"; //get all classes
var URL_STRUCTURE_GET_INDIVIDUAL_BY_BLOCK_ID =
    "$db_host/mobileClasses/block"; //get all classes by block id (:id) gives id
var URL_STRUCTURE_CATEGORIZE =
    "$db_host/mobileClasses/categorize"; //get categorized structure by block id (:id) gives id
var URL_STRUCTURE_CATEGORIZE_ALL =
    "$db_host/mobileClasses/categorizeall"; //get categorized structure by block id (:id) gives id
var URL_GET_ALL_STRUCTURE_BY_CATEGORY =
    "$db_host/mobileClasses/categorizeall/structure"; // get all categorized structure by structure_type (:structure_type)
var URL_GET_ALL_STRUCTURE_BY_BLOCK_ID_AND_STRUCTURE_TYPE =
    "$db_host/mobileClasses/categorizeall/structure"; // get all structure by block_id and structure_type
