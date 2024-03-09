const functions = require("firebase-functions");
const {Storage} = require("@google-cloud/storage");
const admin = require("firebase-admin");
admin.initializeApp(functions.config().firebase);
const spawn = require("child-process-promise").spawn;
const path = require("path");
const os = require("os");
const fs = require("fs");
const db = admin.firestore();

// FUNCTION 1 - copyMoveFileWithinSameStorageBucket
exports.copyMoveFileWithinSameStorageBucket = functions.https.onCall(async (data) => {
  // bucket name for both source file/s/folder/s and destination file/s/folder/s.
  const bucketName = "gs://happening-8133c.appspot.com/";
  // get the path to source file/s/folder/s from data parameter where it needs to copy from.
  const srcPath = data.srcPath;
  // get the path to destination file/s/folder/s from data parameter where it needs to copy to.
  const destPath = data.destPath;
  // get confirmation to delete the source file/s/folder/s from source path.
  const canDelete = data.canDelete;
  // get the colloction name where destination file/s/folder/s URL needs to store to.
  const collectionName = data.collectionName;
  // get the document id where destination file/s/folder/s URL needs to store to.
  const documentID = data.documentID;
  // get the field name where destination file/s/folder/s URL needs to store to.
  const fieldName = data.fieldName;
  // create an object for Storage class by passing service account credentials to its constructor.
  const storage = new Storage({keyFilename: "happening-8133c-firebase-adminsdk-apv26-f49229a567.json"});
  // copy file/s/folder/s to destination file/s/folder/s path from source file/s/folder/s path.
  await storage
      .bucket(bucketName)
      .file(srcPath)
      .copy(storage.bucket(bucketName).file(destPath));
  // once the file/s/folder/s are copied, console log will print the success path outputs.
  console.log(
      `❤️❤️❤️ COPY SUCCESS: ${bucketName}${srcPath} Has Been Copied To ${bucketName}${destPath} Successfully.`,
  );
  // if client confirms to candelete to true, the source file/s/folder/s will be deleted once the copy has been done.
  if (canDelete) {
    await storage
        .bucket(bucketName)
        .file(srcPath)
        .delete();
    // once the source file/s/folder/s are deleted, console log will print the success message output.
    console.log(
        `❤️❤️❤️ DELETE SUCCESS: ${bucketName}${srcPath} Has Been Deleted Successfully.`,
    );
  }
  // once the source file/s/folder/s has been copied or moved(copy&delete), the destination file/s/folder/s location URL needs to be stored in fiestore.
  const bucket = storage.bucket(bucketName);
  const file = bucket.file(destPath);
  // get the signedURL(will expire in the future and won't hve access to read through the URL anymore.(2066 LOL...)).
  const signedUrls = await file.getSignedUrl({
    action: "read",
    expires: "01-01-2066",
  });
  // once we received the URL, it will be printed on the console log.
  console.log(`URL: ${signedUrls[0]}`);
  // a dictionary to create a dictionary that contains fieldname and the URL data.
  const dict = {[fieldName]: signedUrls[0]};
  // after that, it needs to be stored in firestore accourding to given/passed data guidlines.
  await db
      .collection(collectionName)
      .doc(documentID)
      .update(dict);
  console.log(
      `❤️❤️❤️ STORED SUCCESS: ${destPath}'s SignedURL Has Been Stored In '${fieldName}' field at ${collectionName}/${documentID} Successfully.`,
  );
  return {"isCompleted": true};
});

// FUNCTION 2 - generateThumbnail
exports.generateThumbnail = functions.https.onCall(async (data) => {
  const fileBucket = "gs://happening-8133c.appspot.com/"; // The Storage bucket that contains the file.
  const imageFilePath = data.imageFilePath; // File path in the bucket.
  const collectionName = data.collectionName; // Collection name where the thumbnail image needs to store to.
  const documentID = data.documentID; // Document ID where the thumbnail image needs to store to.
  const fieldName = data.fieldName; // Field Name where the thumbnail image needs to store to.
  // Get the file name.
  const fileName = path.basename(imageFilePath);
  // Exit if the image is already a thumbnail.
  if (fileName.endsWith("_THUMB")) {
    return functions.logger.log("🌄🌄🌄 ALREADY A THUMBNAIL");
  }
  // Download file from bucket.
  const storage = new Storage({keyFilename: "happening-8133c-firebase-adminsdk-apv26-f49229a567.json"});
  const bucket = storage.bucket(fileBucket);
  const tempFilePath = path.join(os.tmpdir(), fileName);

  await bucket.file(imageFilePath).download({destination: tempFilePath});
  functions.logger.log("⬇️⬇️⬇️ IMAGE DOWNLOADED LOCALLY TO: ", tempFilePath);
  // Generate a thumbnail using ImageMagick.
  await spawn("convert", [tempFilePath, "-thumbnail", "200x200>", tempFilePath]);
  functions.logger.log("👉🏿👉🏿👉🏿 THUMBNAIL CREATED AT: ", tempFilePath);
  // We add a '_THUMB' suffix to thumbnails file name. That's where we'll upload the thumbnail.
  const thumbFileName = `${fileName}_THUMB`;
  const thumbFilePath = path.join(path.dirname(imageFilePath), thumbFileName);
  // Uploading the thumbnail.
  await bucket.upload(tempFilePath, {
    destination: thumbFilePath,
  });
  const file = bucket.file(thumbFilePath);
  // get the signedURL(will expire in the future and won't hve access to read through the URL anymore.(2066 LOL...)).
  const signedUrls = await file.getSignedUrl({
    action: "read",
    expires: "01-01-2066",
  });
  // once we received the URL, it will be printed on the console log.
  console.log(`URL: ${signedUrls[0]}`);
  // a dictionary to create a dictionary that contains fieldname and the URL data.
  const dict = {[fieldName]: signedUrls[0]};
  // after that, it needs to be stored in firestore accourding to given/passed data guidlines.
  await db
      .collection(collectionName)
      .doc(documentID)
      .update(dict);
  // Once the thumbnail has been uploaded delete the local file to free up disk space.
  fs.unlinkSync(tempFilePath);
  console.log(
      `🖤🖤🖤 STORED SUCCESS: ${thumbFilePath}'s SignedURL Has Been Stored In '${fieldName}' field at ${collectionName}/${documentID} Successfully.`,
  );
  return {"isCompleted": true};
});

// FUNCTION 3 - createAHappenning
exports.createAHappening = functions.https.onCall(async (data) => {
  const title = data.title; // Happening title
  const photosData = data.photosData; // Happening photos data array
  const description = data.description; // Happening description
  const startingDateAndTime = data.startingDateAndTime; // Starting date & time of the happening.
  const endingDateAndTime = data.endingDateAndTime; // Ending date & time of the happening.
  const standardStartingDT = data.standardStartingDT; // Standard starting date and time for sorting purposes.
  const standardEndingDT = data.standardEndingDT; // Standard ending date and time for sorting purposes.
  const latitude = data.latitude; // Latitude coordinate of happening location.
  const longitude = data.longitude; // Longitude coordinate of happening location.
  const address = data.address; // address of the happening location.
  const secureAddress = data.secureAddress; // limited address access to the happening location for unknown users.
  const spaces = data.spaces; // Number of spaces of the happening.
  const spaceFee = data.spaceFee; // One space fee of the happening.
  const spaceFlag = data.spaceFlag; // whether the spaces are available or not.
  const dueFlag = data.dueFlag; // whether the happening is ended or not.
  const disputeFlag = data.disputeFlag; // whether the happening has any disputes or not.
  const numberOfDisputes = data.numberOfDisputes; // number of disputes from followers.
  const uid = data.uid; // current user uid.
  const spaceFeeNo = data.spaceFeeNo; // store space fee as a number so we can query it easily.
  const participators = data.participators; // store participators ids in an array.
  const collectionName = data.collectionName; // Collection name where all the required data need to be stored in firestore.
  const docID = data.docID; // unique id to create a document in firestore and to store photos in the storage with a unique folder.
  const fieldName = data.fieldName; // Field Name where the thumbnail image needs to store to.
  const storage = new Storage({keyFilename: "happening-8133c-firebase-adminsdk-apv26-f49229a567.json"});
  const fileBucket = "gs://happening-8133c.appspot.com/"; // The Storage bucket where images need to copy to.
  const imageFilePath = `Happening Data/Happening Photos/${data.userUID}/${docID}/0`; // File path in the bucket. <<-------- change here with a id
  const signedURLArray = []; // signed urls of the uploaded images will be stored here.
  const bucket = storage.bucket(fileBucket);
  // Upload photos data one by one to firebase storage.
  for (let i = 0; i < photosData.length; i++) {
    const imgData = photosData[i];
    const file = bucket.file(`Happening Data/Happening Photos/${data.userUID}/${docID}/${i}`);
    const imgBuffer = Buffer.from(imgData, "base64");
    await file.save(imgBuffer, {
      contentType: "image/jpeg",
    }).catch((err) => {
      console.error("🚫🚫🚫 UPLOAD ERROR", err);
    });
    // once the file/s/folder/s are copied, console log will print the success path outputs.
    console.log(
        `❤️❤️❤️ UPLOAD SUCCESS[${i}]: Uploaded to Happening Data/Happening Photos/${data.userUID}/${docID}/${i}`,
    );
    // get the signedURL(will expire in the future and won't hve access to read through the URL anymore.(2066 LOL...)).
    const signedUrls = await file.getSignedUrl({
      action: "read",
      expires: "01-01-2066",
    });
    // Append each and every signed url to the signedURLArray.
    signedURLArray.push(signedUrls[0]);
  }
  // Get the file name.
  const fileName = path.basename(imageFilePath);
  // Exit if the image is already a thumbnail.
  if (fileName.endsWith("_THUMB")) {
    return functions.logger.log("🌄🌄🌄 ALREADY A THUMBNAIL");
  }
  // Download file from bucket.
  const tempFilePath = path.join(os.tmpdir(), fileName);

  await bucket.file(imageFilePath).download({destination: tempFilePath});
  functions.logger.log("⬇️⬇️⬇️ IMAGE DOWNLOADED LOCALLY TO: ", tempFilePath);
  // Generate a thumbnail using ImageMagick.
  await spawn("convert", [tempFilePath, "-thumbnail", "200x200>", tempFilePath]);
  functions.logger.log("👉🏿👉🏿👉🏿 THUMBNAIL CREATED AT: ", tempFilePath);
  // We add a '_THUMB' suffix to thumbnails file name. That's where we'll upload the thumbnail.
  const thumbFileName = `${fileName}_THUMB`;
  const thumbFilePath = path.join(path.dirname(imageFilePath), thumbFileName);
  // Uploading the thumbnail.
  await bucket.upload(tempFilePath, {
    destination: thumbFilePath,
    contentType: "image/jpeg",
  });
  const file = bucket.file(thumbFilePath);
  // get the signedURL(will expire in the future and won't hve access to read through the URL anymore.(2066 LOL...)).
  const signedUrls = await file.getSignedUrl({
    action: "read",
    expires: "01-01-2066",
  });
  // once we received the URL, it will be printed on the console log.
  console.log(`URL: ${signedUrls[0]}`);
  // a dictionary to create a dictionary that contains fieldname and the URL data.
  const dict = {
    [fieldName]: signedUrls[0],
    Title: title,
    PhotosArray: signedURLArray,
    Description: description,
    DateAndTime: {
      Starting: startingDateAndTime,
      Ending: endingDateAndTime,
      SSDT: standardStartingDT,
      SEDT: standardEndingDT,
    },
    Location: {
      Latitude: latitude,
      Longitude: longitude,
      Address: address,
      SecureAddress: secureAddress,
    },
    Spaces: spaces,
    SpaceFee: spaceFee,
    Timestamp: admin.firestore.FieldValue.serverTimestamp(),
    SpaceFlag: spaceFlag,
    DueFlag: dueFlag,
    DisputeFlag: disputeFlag,
    NumberOfDisputes: numberOfDisputes,
    UID: uid,
    SpaceFeeNo: spaceFeeNo,
    Participators: participators,
  };
  // after that, it needs to be stored in firestore accourding to given/passed data guidlines.
  await db
      .collection(collectionName)
      .doc(docID)
      .set(dict);
  // Once the thumbnail has been uploaded delete the local file to free up disk space.
  fs.unlinkSync(tempFilePath);
  console.log(
      "🖤🖤🖤 STORED SUCCESS: All the Happening data has been stored successfully in the firebase.",
  );
  return {"isCompleted": true};
});

// FUNCTION 4 - followUser
exports.followUser = functions.https.onCall(async (data) => {
  const myDocID = data.myDocID;
  const userDocID = data.userDocID;
  const collectionName = data.collectionName;
  const followersSubCName = data.followersSubCName;
  const followingSubCName = data.followingSubCName;
  const dataDictionary = {
    FollowedDT: admin.firestore.FieldValue.serverTimestamp(),
    isBlocked: false,
  };
  // change my side first
  await db
      .collection(`${collectionName}/${myDocID}/${followingSubCName}`)
      .doc(userDocID)
      .set(dataDictionary);

  console.log(
      "🖤🖤🖤 CREATE SUCCESS: The user has been created as a following in my side in the firestore.",
  );

  // change users side
  await db
      .collection(`${collectionName}/${userDocID}/${followersSubCName}`)
      .doc(myDocID)
      .set(dataDictionary);

  console.log(
      "🖤🖤🖤 CREATE SUCCESS: I have been created as a follower in  users side in the firestore.",
  );
  return {"isCompleted": true};
});

// FUNCTION 5 - unfollowUser
exports.unfollowUser = functions.https.onCall(async (data) => {
  const myDocID = data.myDocID;
  const userDocID = data.userDocID;
  const collectionName = data.collectionName;
  const followersSubCName = data.followersSubCName;
  const followingSubCName = data.followingSubCName;

  // change my side first
  await db
      .collection(`${collectionName}/${myDocID}/${followingSubCName}`)
      .doc(userDocID)
      .delete().catch((err) => {
        console.error("🚫🚫🚫 DELETE ERROR", err);
      });

  console.log(
      "🖤🖤🖤 DELETE SUCCESS: The user has been deleted as a following in my side in the firestore.",
  );

  // change users side
  await db
      .collection(`${collectionName}/${userDocID}/${followersSubCName}`)
      .doc(myDocID)
      .delete().catch((err) => {
        console.error("🚫🚫🚫 DELETE ERROR", err);
      });

  console.log(
      "🖤🖤🖤 DELETE SUCCESS: I have been deleted as a follower in  users side in the firestore.",
  );
  return {"isCompleted": true};
});

// FUNCTION 6 - removeFollower
exports.removeFollower = functions.https.onCall(async (data) => {
  const myDocID = data.myDocID;
  const userDocID = data.userDocID;
  const collectionName = data.collectionName;
  const followersSubCName = data.followersSubCName;
  const followingSubCName = data.followingSubCName;

  // change my side first
  await db
      .collection(`${collectionName}/${myDocID}/${followersSubCName}`)
      .doc(userDocID)
      .delete().catch((err) => {
        console.error("🚫🚫🚫 DELETE ERROR", err);
      });

  console.log(
      "🖤🖤🖤 DELETE SUCCESS: The user has been deleted as a follower in my side in the firestore.",
  );

  // change users side
  await db
      .collection(`${collectionName}/${userDocID}/${followingSubCName}`)
      .doc(myDocID)
      .delete().catch((err) => {
        console.error("🚫🚫🚫 DELETE ERROR", err);
      });

  console.log(
      "🖤🖤🖤 DELETE SUCCESS: I have been deleted as a following in  users side in the firestore.",
  );
  return {"isCompleted": true};
});

// FUNCTION 7 - blockUser
exports.blockUser = functions.https.onCall(async (data) => {
  const myDocID = data.myDocID;
  const userDocID = data.userDocID;
  const collectionName = data.collectionName;
  const followersSubCName = data.followersSubCName;
  const followingSubCName = data.followingSubCName;
  const blockDictionary = {
    isBlocked: true,
    Blockedby: myDocID,
    BlockedDT: admin.firestore.FieldValue.serverTimestamp(),
  };
  // change my side first
  await db
      .collection(`${collectionName}/${myDocID}/${followersSubCName}`)
      .doc(userDocID)
      .update(blockDictionary).catch((err) => {
        console.error("🚫🚫🚫 UPDATE ERROR", err);
      });

  await db
      .collection(`${collectionName}/${myDocID}/${followingSubCName}`)
      .doc(userDocID)
      .update(blockDictionary).catch((err) => {
        console.error("🚫🚫🚫 UPDATE ERROR", err);
      });

  console.log(
      "🖤🖤🖤 BLOCKED SUCCESS: The user has been blocked as a follower & following in my side in the firestore.",
  );

  // change users side
  await db
      .collection(`${collectionName}/${userDocID}/${followersSubCName}`)
      .doc(myDocID)
      .update(blockDictionary).catch((err) => {
        console.error("🚫🚫🚫 UPDATE ERROR", err);
      });

  await db
      .collection(`${collectionName}/${userDocID}/${followingSubCName}`)
      .doc(myDocID)
      .update(blockDictionary).catch((err) => {
        console.error("🚫🚫🚫 UPDATE ERROR", err);
      });

  console.log(
      "🖤🖤🖤 BLOCKED SUCCESS: I have been blocked as a follower & following in  users side in the firestore.",
  );
  return {"isCompleted": true};
});

// FUNCTION 8 - unblockUser
exports.unblockUser = functions.https.onCall(async (data) => {
  const myDocID = data.myDocID;
  const userDocID = data.userDocID;
  const collectionName = data.collectionName;
  const followersSubCName = data.followersSubCName;
  const followingSubCName = data.followingSubCName;
  const blockDictionary = {
    isBlocked: false,
    Blockedby: "",
  };
  // change my side first
  await db
      .collection(`${collectionName}/${myDocID}/${followersSubCName}`)
      .doc(userDocID)
      .update(blockDictionary).catch((err) => {
        console.error("🚫🚫🚫 UPDATE ERROR", err);
      });

  await db
      .collection(`${collectionName}/${myDocID}/${followingSubCName}`)
      .doc(userDocID)
      .update(blockDictionary).catch((err) => {
        console.error("🚫🚫🚫 UPDATE ERROR", err);
      });

  console.log(
      "🖤🖤🖤 BLOCKED SUCCESS: The user has been blocked as a follower & following in my side in the firestore.",
  );

  // change users side
  await db
      .collection(`${collectionName}/${userDocID}/${followersSubCName}`)
      .doc(myDocID)
      .update(blockDictionary).catch((err) => {
        console.error("🚫🚫🚫 UPDATE ERROR", err);
      });

  await db
      .collection(`${collectionName}/${userDocID}/${followingSubCName}`)
      .doc(myDocID)
      .update(blockDictionary).catch((err) => {
        console.error("🚫🚫🚫 UPDATE ERROR", err);
      });

  console.log(
      "🖤🖤🖤 BLOCKED SUCCESS: I have been blocked as a follower & following in  users side in the firestore.",
  );
  return {"isCompleted": true};
});

// FUNCTION 9 - reserveASpace
exports.reserveASpace = functions.https.onCall(async (data) => {
  const userUID = data.userUID;
  const creatorID = data.creatorID;
  const happeningDocID = data.happeningDocID;
  let maxSpaces;
  let currentParticipatorsCount;
  let availableSpaces = maxSpaces - currentParticipatorsCount;

  try {
    await db
        .collection(`Users/${creatorID}/HappeningData`)
        .doc(happeningDocID)
        .get().then((documentSnapshot) => {
          maxSpaces = documentSnapshot.data()["Spaces"];
          console.log(`Number of Spaces: ${maxSpaces}`);
          currentParticipatorsCount = documentSnapshot.data()["Participators"].length;
          console.log(`Current ParticipatorsCount: ${currentParticipatorsCount}`);
          availableSpaces = maxSpaces - currentParticipatorsCount;
          console.log(`Available Spaces: ${availableSpaces}`);
        });

    if (availableSpaces > 0) {
      let dic = {};

      if (availableSpaces == 1) {
        dic = {
          Participators: admin.firestore.FieldValue.arrayUnion(userUID),
          SpaceFlag: "closed",
        };
      } else {
        dic = {
          Participators: admin.firestore.FieldValue.arrayUnion(userUID),
        };
      }

      await db
          .collection(`Users/${creatorID}/HappeningData`)
          .doc(happeningDocID)
          .update(dic).catch((err) => {
            console.error("🚫🚫🚫 UPDATE ERROR", err);
          });

      const dic2 = {
        TimeStamp: admin.firestore.FieldValue.serverTimestamp(),
        HappeningID: happeningDocID,
        CreatorID: creatorID,
        isEnded: false,
      };

      await db
          .collection(`Users/${userUID}/ReservedHappenings`)
          .add(dic2).catch((err) => {
            console.error("🚫🚫🚫 CREATE ERROR", err);
          });
      console.log(
          "❤️❤️❤️ RESERVATION SUCCESS: A space reservation has been successfully done.",
      );
      return {"isCompleted": true};
    } else {
      console.log(
          "🚫🚫🚫 RESERVATION FAILED: No spaces available.",
      );
    }
  } catch (error) {
    console.log(`Error: ${error}🚫🚫🚫`);
    return {"isCompleted": false};
  }
});

// FUNCTION 10 - sendAMessage
exports.sendAMessage = functions.https.onCall(async (data) => {
  const chatDocID = data.chatDocID;
  const happeningDocID = data.happeningDocID;
  const happeningTitle = data.happeningTitle;
  const senderUID = data.senderUID;
  const receiverUID = data.receiverUID;
  const msgText = data.msgText;
  const sentTime = data.sentTime;
  const sentTimeFull = data.sentTimeFull;

  try {
    // create sender's documents first.
    const ref1 = db
        .collection(`Users/${senderUID}/ChatData`)
        .doc(chatDocID);

    await ref1.set({
      HappeningDocID: happeningDocID,
      HappeningTitle: happeningTitle,
      SenderUID: senderUID,
      ReceiverUID: receiverUID,
      MsgText: msgText,
      isSent: true,
      isDelivered: false,
      isRead: false,
      SentTime: sentTime,
      SentTimeFull: sentTimeFull,
      ChatDocID: ref1.id,
      Reaction: "",
    });
    console.log(
        "❤️❤️❤️ SUCCESS: A message has been added to the sender's chat thread successfully.",
    );

    // create receiver's documents second.
    const ref2 = db
        .collection(`Users/${receiverUID}/ChatData`)
        .doc(ref1.id);

    await ref2.set({
      HappeningDocID: happeningDocID,
      HappeningTitle: happeningTitle,
      SenderUID: senderUID,
      ReceiverUID: receiverUID,
      MsgText: msgText,
      SentTime: sentTime,
      SentTimeFull: sentTimeFull,
      isUpdated: false,
      ChatDocID: ref1.id,
      Reaction: "",
    });
    console.log(
        "❤️❤️❤️ SUCCESS: A message has been added to the receiver's chat thread successfully.",
    );
    return {"isCompleted": true};
  } catch (error) {
    console.log(`Error: ${error}🚫🚫🚫`);
    return {"isCompleted": false};
  }
});

// FUNCTION 11 - flagAMessage
exports.flagAMessage = functions.https.onCall(async (data) => {
  const chatDocID = data.chatDocID;
  const creatorsUID = data.creatorsUID;
  const myUserUID = data.myUserUID;
  const isRead = data.isRead;

  // update creator's document first
  try {
    await db
        .collection(`Users/${creatorsUID}/ChatData`)
        .doc(chatDocID)
        .update({
          isDelivered: true,
          isRead: isRead,
        });
    console.log(
        `❤️❤️❤️ SUCCESS: Creator's (${chatDocID}) message document has been updated successfully.`,
    );

    // update my document second
    await db
        .collection(`Users/${myUserUID}/ChatData`)
        .doc(chatDocID)
        .update({
          isUpdated: isRead,
        });
    console.log(
        `❤️❤️❤️ SUCCESS: Participator's (${chatDocID}) message document has been updated successfully.`,
    );
    return {"isCompleted": true};
  } catch (error) {
    console.log(`Error: ${error}🚫🚫🚫`);
    return {"isCompleted": false};
  }
});

// FUNCTION 12 - uploadATextBasedMemory
exports.uploadATextBasedMemory = functions.https.onCall(async (data) => {
  const docID = data.docID;
  const myDocID = data.myDocID;
  const memoryType = "textBased";
  const colorName = data.colorName;
  const fontName = data.fontName;
  const text = data.text;
  const uploadedDate = data.uploadedDate;
  const uploadedTime = data.uploadedTime;
  const fullUploadedDT = data.fullUploadedDT;
  const dataDictionary = {
    MemoryDocID: docID,
    MemoryType: memoryType,
    ColorName: colorName,
    FontName: fontName,
    Text: text,
    UploadedDate: uploadedDate,
    UploadedTime: uploadedTime,
    FullUploadedDT: fullUploadedDT,
  };

  try {
    await db
        .collection(`Users/${myDocID}/MemoriesData`)
        .doc(docID)
        .set(dataDictionary);

    console.log(
        "🖤🖤🖤 CREATE SUCCESS: A memory has been created successfully.",
    );
    return {"isCompleted": true};
  } catch (error) {
    console.log(`Error: ${error}🚫🚫🚫`);
    return {"isCompleted": false};
  }
});

// FUNCTION 13 - deleteAMemory
exports.deleteAMemory = functions.https.onCall(async (data) => {
  const docID = data.docID;
  const myDocID = data.myDocID;

  try {
    await db
        .collection(`Users/${myDocID}/MemoriesData`)
        .doc(docID)
        .delete();

    console.log(
        "🖤🖤🖤 DELETE SUCCESS: A my memory has been deleted successfully.",
    );

    await admin
        .storage()
        .bucket()
        .deleteFiles({prefix: `My Memories Data/Image Based Memory Photos/${myDocID}/${docID}`});

    console.log(
        "🖤🖤🖤 DELETE SUCCESS: A my memory image folder has been deleted successfully.",
    );

    return {"isCompleted": true};
  } catch (error) {
    console.log(`Error: ${error}🚫🚫🚫`);
    return {"isCompleted": true};
  }
});

// FUNCTION 14 - uploadAnImageBasedMemory
exports.uploadAnImageBasedMemory = functions.https.onCall(async (data) => {
  const docID = data.docID;
  const myDocID = data.myDocID;
  const memoryType = "imageBased";
  const imageData = data.imageData;
  const caption = data.caption;
  const uploadedDate = data.uploadedDate;
  const uploadedTime = data.uploadedTime;
  const fullUploadedDT = data.fullUploadedDT;
  const storage = new Storage({keyFilename: "happening-8133c-firebase-adminsdk-apv26-f49229a567.json"});
  const fileBucket = "gs://happening-8133c.appspot.com/"; // The Storage bucket where images need to copy to.
  const imageFilePath = `My Memories Data/Image Based Memory Photos/${myDocID}/${docID}/memoryImage`; // File path in the bucket.
  const bucket = storage.bucket(fileBucket);
  const imgBuffer = Buffer.from(imageData, "base64");
  const file1 = bucket.file(`My Memories Data/Image Based Memory Photos/${myDocID}/${docID}/memoryImage`);

  try {
    await file1.save(imgBuffer, {
      contentType: "image/jpeg",
    }).catch((err) => {
      console.error("🚫🚫🚫 UPLOAD ERROR", err);
    });
    // once the file/s/folder/s are copied, console log will print the success path outputs.
    console.log(
        `❤️❤️❤️ UPLOAD SUCCESS: Uploaded to My Memories Data/Image Based Memory Photos/${myDocID}/${docID}`,
    );
    // get the signedURL(will expire in the future and won't hve access to read through the URL anymore.(2066 LOL...)).
    const signedUrls1 = await file1.getSignedUrl({
      action: "read",
      expires: "01-01-2066",
    });
    // once we received the URL, it will be printed on the console log.
    console.log(`URL: ${signedUrls1[0]}`);

    // Get the file name.
    const fileName = path.basename(imageFilePath);
    // Exit if the image is already a thumbnail.
    if (fileName.endsWith("_THUMB")) {
      return functions.logger.log("🌄🌄🌄 ALREADY A THUMBNAIL");
    }
    // Download file from bucket.
    const tempFilePath = path.join(os.tmpdir(), fileName);

    await bucket.file(imageFilePath).download({destination: tempFilePath});
    functions.logger.log("⬇️⬇️⬇️ IMAGE DOWNLOADED LOCALLY TO: ", tempFilePath);
    // Generate a thumbnail using ImageMagick.
    await spawn("convert", [tempFilePath, "-thumbnail", "200x200>", tempFilePath]);
    functions.logger.log("👉🏿👉🏿👉🏿 THUMBNAIL CREATED AT: ", tempFilePath);
    // We add a '_THUMB' suffix to thumbnails file name. That's where we'll upload the thumbnail.
    const thumbFileName = `${fileName}_THUMB`;
    const thumbFilePath = path.join(path.dirname(imageFilePath), thumbFileName);
    // Uploading the thumbnail.
    await bucket.upload(tempFilePath, {
      destination: thumbFilePath,
      contentType: "image/jpeg",
    });
    const file2 = bucket.file(thumbFilePath);
    // get the signedURL(will expire in the future and won't hve access to read through the URL anymore.(2066 LOL...)).
    const signedUrls2 = await file2.getSignedUrl({
      action: "read",
      expires: "01-01-2066",
    });
    // once we received the URL, it will be printed on the console log.
    console.log(`URL: ${signedUrls2[0]}`);

    const dataDictionary = {
      MemoryDocID: docID,
      MemoryType: memoryType,
      ImageThumbnailURL: signedUrls2[0],
      ImageURL: signedUrls1[0],
      Caption: caption,
      UploadedDate: uploadedDate,
      UploadedTime: uploadedTime,
      FullUploadedDT: fullUploadedDT,
    };
    // after that, it needs to be stored in firestore accourding to given/passed data guidlines.
    await db
        .collection(`Users/${myDocID}/MemoriesData`)
        .doc(docID)
        .set(dataDictionary);
    // Once the thumbnail has been uploaded delete the local file to free up disk space.
    fs.unlinkSync(tempFilePath);
    console.log(
        "🖤🖤🖤 STORED SUCCESS: An Image Based Memory has been stored successfully in the firebase.",
    );
    return {"isCompleted": true};
  } catch (error) {
    console.log(`Error: ${error}🚫🚫🚫`);
    return {"isCompleted": false};
  }
});

// FUNCTION 15 - setSeenFlagForAFollowingsMemory
exports.setSeenFlagForAFollowingsMemory = functions.https.onCall(async (data) => {
  const seenMemoryDocID = data.seenMemoryDocID;
  const fullSeenDT = data.fullSeenDT;
  const seenDate = data.seenDate;
  const seenTime = data.seenTime;
  const seenerUID = data.seenerUID;
  const followingUserUID = data.followingUserUID;

  try {
    // first we need to get all of the memory seeners data from the given following user to check
    // whether I have seen already seen a purticular memory before or not
    const query = db.collection(`Users/${followingUserUID}/MemorySeenersData`)
        .where("SeenMemoryDocID", "==", `${seenMemoryDocID}`)
        .where("SeenerUID", "==", `${seenerUID}`);

    await query.get().then((querySnapshot) => {
      if (querySnapshot.empty) {
        // create participator's documents first.
        const ref = db
            .collection(`Users/${followingUserUID}/MemorySeenersData`)
            .doc(); // creates a document reference with an auto-generated ID, then use the reference later.

        ref.set({
          SeenMemoryDocID: seenMemoryDocID,
          FullSeenDT: fullSeenDT,
          SeenDate: seenDate,
          SeenTime: seenTime,
          SeenerUID: seenerUID,
        });
        console.log(
            `❤️❤️❤️ SUCCESS: ${seenMemoryDocID} Following User's Memory Item Has Been Flagged As Seen Successfully.`,
        );
      } else {
        console.log(
            `👋👋👋 NOTICE: ${seenMemoryDocID} Following User's Memory Item Has Been Flagged As Seen Before.`,
        );
      }
    });
    return {"isCompleted": true};
  } catch (error) {
    console.log(`Error: ${error}🚫🚫🚫`);
    return {"isCompleted": false};
  }
});

// FUNCTION 16 - updateAMessageReaction
exports.updateAMessageReaction = functions.https.onCall(async (data) => {
  const chatDocID = data.chatDocID;
  const user1UID = data.user1UID;
  const user2UID = data.user2UID;
  const reaction = data.reaction;

  // update user1's document first
  try {
    await db
        .collection(`Users/${user1UID}/ChatData`)
        .doc(chatDocID)
        .update({
          Reaction: reaction,
        });
    console.log(
        `❤️❤️❤️ SUCCESS: User1's (${chatDocID}) message document has been updated successfully.`,
    );

    // update user2's document second
    await db
        .collection(`Users/${user2UID}/ChatData`)
        .doc(chatDocID)
        .update({
          Reaction: reaction,
        });
    console.log(
        `❤️❤️❤️ SUCCESS: User2's (${chatDocID}) message document has been updated successfully.`,
    );
    return {"isCompleted": true};
  } catch (error) {
    console.log(`Error: ${error}🚫🚫🚫`);
    return {"isCompleted": false};
  }
});

// FUNCTION 17 - updateIsTypingFlag
exports.updateIsTypingFlag = functions.https.onCall(async (data) => {
  const happeningDocID = data.happeningDocID;
  const typingUserUID = data.typingUserUID;
  const myUserUID = data.myUserUID;
  const isTyping = data.isTyping;

  try {
    await db
        .collection("TypingChatData")
        .doc(`${happeningDocID}${myUserUID}`)
        .set({
          HappeningDocID: happeningDocID,
          TypingUserUID: typingUserUID,
          myUserUID: myUserUID,
          isTyping: isTyping,
        });
    console.log(
        `❤️❤️❤️ SUCCESS: User (${typingUserUID}) Is Typing...`,
    );
    return {"isCompleted": true};
  } catch (error) {
    console.log(`Error: ${error}🚫🚫🚫`);
    return {"isCompleted": false};
  }
});

// FUNCTION 18 - setIsTypingToFalse
exports.setIsTypingToFalse = functions.pubsub.schedule("every 1 minutes").onRun((context) => {
  db.collection("TypingChatData").where("isTyping", "==", true).get().then(function(querySnapshot) {
    querySnapshot.forEach(function(doc) {
      doc.ref.update({
        isTyping: false,
      });
    });
  });
  console.log("❤️❤️❤️ SUCCESS: 'isTyping' Flag Has Been Set To False For All Users.");
  return null;
});

// FUNCTION 19 - updateHappeningsDueFlag
// exports.updateHappeningsDueFlag = functions.pubsub.schedule("every 1 minutes").onRun((context) => {
//   try {
//     const query = db.collection("Users").where("dueFlag", "==", "live");

//     query.get().then((querySnapshot) => {
//       const docs = querySnapshot.docs;
//       const formatNowDT = new Date().toISOString().slice(0, 10).replace(/-/g, "-").replace("T", " ");
//       console.log(`${formatNowDT} ❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️`);

//       for (const doc of docs) {
//         const uid = doc.data()["uid"];
//         console.log(`UID: ${uid}`);
//         if (doc.data()["SEDT"].slice(0, 11) < formatNowDT) {
//           db
//               .collection(`Users/${uid}/HappeningData`)
//               .doc(doc.id)
//               .update({
//                 dueFlag: "ended",
//                 spaceFlag: "closed",
//               });
//         }
//       }
//     });
//   } catch (error) {
//     console.log(`Error: ${error}🚫🚫🚫`);
//   }
//   console.log("🖤🖤🖤🖤🖤🖤🖤🖤🖤🖤🖤");
//   return null;
// });

// exports.hello = functions.https.onRequest((request, response) => {
//   try {
//     const query = db.collection("Users").where("dueFlag", "==", "live");

//     query.get().then((querySnapshot) => {
//       const docs = querySnapshot.docs;
//       const formatNowDT = new Date().toISOString().slice(0, 10).replace(/-/g, "-").replace("T", " ");
//       console.log(`${formatNowDT} ❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️`);

//       for (const doc of docs) {
//         response.send(`${doc.data()["uid"]} ❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️`);
//         const uid = doc.data()["uid"];
//         console.log(`UID: ${uid}`);
//         if (doc.data()["SEDT"].slice(0, 10) < formatNowDT) {
//           db
//               .collection(`Users/${uid}/HappeningData`)
//               .doc(doc.id)
//               .update({
//                 dueFlag: "ended",
//                 spaceFlag: "closed",
//               });
//         }
//       }
//     });
//   } catch (error) {
//     console.log(`Error: ${error}🚫🚫🚫`);
//   }
// });
