//
//  ServerKeys.h
//  TradeRoomClient
//
//  Created by Taylor James Cressy on 4/29/14.
//  Copyright (c) 2014 TradeRoom. All rights reserved.
//

#ifndef TradeRoomClient_ServerKeys_h
#define TradeRoomClient_ServerKeys_h

#define USER @"user"
#define AUTHENTICATION @"2FCC2E5118FAAEA725449AD74E2FAEC450842311D9F045C610FEA8A8EA55FA76"

//ServerMessage Keys
#define SRV_MSG_KEY @"message"
#define SRV_CODE_KEY @"code"
#define SRV_DATA_KEY @"data"

//Request URLs
#define GET_USER_DETAILS @"/user/getAccountDetails"
#define REGISTER_REQUEST @"/user/register"
#define LOGIN_REQUEST @"/user/login"
#define LOGOUT_REQUEST @"/user/logout"
#define FACEBOOK_LOGIN @"/user/loginWithFacebook"
#define UPDATE_EMAIL_REQUEST @"/user/updateEmail"
#define UPDATE_ACCOUNT_REQUEST @"/user/updatePreferences"
#define UPDATE_ADDRESS @"/user/updateAddress"
#define GET_FRIEND_DETAILS @"/user/friends/getAccountDetailsOfUser"
#define GET_ALL_FRIENDS @"/user/friends/retrieveAllFriends"
#define SEND_FRIEND_REQUEST @"/user/friends/sendFriendRequest"
#define RESPOND_TO_FRIEND_REQUEST @"/user/friends/respondToFriendRequest"
#define GET_ALL_USERS_WITH_IDS @"/user/friends/retrieveUsersWithIds"
#define GET_ALL_FACEBOOK_USERS @"/user/friends/retrieveAllUsersWithFacebookIds"
#define ADD_TRADE_ITEM_REQUEST @"/user/items/addTradeItem"
#define GET_TRADE_ITEMS @"/user/items/retrieveItemsFromList"
#define UPDATE_TRADE_ITEM @"/user/items/updateTradeItem"
#define REMOVE_TRADE_ITEM @"/user/items/removeTradeItem"
#define ADD_IMAGE_TO_TRADE_ITEM @"/user/items/addImageToTradeItem"
#define GET_IMAGE_BY_ID @"/user/items/getImageById"
#define REMOVE_IMAGE_BY_ID @"/user/items/removeImageById"
#define UPDATE_CURRENT_LOCATION @"/location/updateCurrentLocation"
#define SEARCH_FOR_USER @"/search/searchForUser"
#define SEARCH_FOR_ITEM @"/search/searchForItem"

//Resource Request URLs
#define CONDITIONS_LIST_REQUEST @"/resource/getConditionsList"
#define TRADE_OPTIONS_LIST_REQUEST @"/resource/getTradeOptions"

//Parameter/Field Keys
#define OBJECT_ID @"id"
#define USER_ID_KEY @"userId"
#define USER_ID_MULT_KEY @"userIds"
#define USERNAME_KEY @"username"
#define PASSWORD_KEY @"password"
#define EMAIL_KEY @"email"
#define FIRST_NAME_KEY @"firstName"
#define LAST_NAME_KEY @"lastName"
#define BIRTH_DAY_KEY @"dob"
#define FACEBOOK_ID @"facebookId"
#define FACEBOOK_ID_MULT @"facebookIds"
#define FACEBOOK_AUTH_TOKEN @"authToken"
#define MAX_NUMBER_OF_ITEMS @"maxTradeItemCount"
#define MAX_NUMBER_OF_IMAGES @"maxItemImageCount"
#define NUMBER_OF_SUCCESSFUL_TRADES_KEY @"numberOfSuccessfulTrades"
#define NUMBER_OF_ITEMS @"numberOfItems"
#define DATE_USER_JOINED_KEY @"dateJoined"
#define DATE_LAST_LOGIN_KEY @"lastLogin"
#define ADDRESS_KEY @"address"
#define ITEM_ARRAY_IDS @"itemIds"
#define ADDR_STREET_NUM @"streetNumber"
#define ADDR_STREET_NAME @"streetName"
#define ADDR_CITY @"city"
#define ADDR_COUNTY @"county"
#define ADDR_COUNTRY @"country"
#define ADDR_POSTCODE @"areaCode"

    //Item Keys
#define ITEM_IMAGE @"Image" 
#define ITEM_ID_KEY @"itemId"
#define ITEM_NAME_KEY @"name"
#define ITEM_DESCRIPTION_KEY @"description"
#define ITEM_TAGS_KEY @"tags"
#define ITEM_COUNT_KEY @"count"
#define ITEM_CONDITION_KEY @"condition"
#define ITEM_DATE_ADDED_KEY @"dateAdded"
#define ITEM_OWNER_ID @"ownerId"
#define ITEM_IMAGE_KEY @"imageId"
#define ITEM_IMAGE_ARRAY_KEY @"imageIds"

    //Geo Location
#define CURRENT_CITY @"city"
#define CURRENT_LONGITUDE @"longitude"
#define CURRENT_LATITUDE @"latitude"

    //Search Queries
#define SEARCH_QUERY_KEY @"query"

    //Friend Request Queries
#define FRIEND_REQUEST_FROM @"senderId"
#define FRIEND_REQUEST_TO @"receiverId"
#define FRIEND_REQUEST_STATUS @"status"
#define FRIEND_REQUEST_ACCEPTED @"ACCEPTED"
#define FRIEND_REQUEST_DENINED @"DENIED"
#define FRIEND_REQUEST_BLOCKED @"BLOCKED"

//Error Keys
#define INVALID_FIELD_KEY @"invalidField"
#define REASON_FOR_ERROR_KEY @"reason"

//Dictionary Sub-Dict Keys
#define DICT_ACCOUNT_PREF @"accountPreference"
#define DICT_TRADE_ROOM_META @"tradeRoomMeta"

//Sub-Array Keys
#define ARR_FRIEND_REQUESTS @"friendRequests"

#endif
