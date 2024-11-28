/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// const { onRequest} = require("firebase-functions/v2/https");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
exports.exampleFunction = functions.https.onRequest((request, response) => {
  response.send("Hello from Firebase!");
});
// const messaging = admin.messaging();


// exports.sendBloodRequestNotification = async (req, res) => {
//     const { tokens, title, body } = req.body;

//     const message = {
//         notification: {
//             title: title,
//             body: body,
//         },
//         tokens: tokens,
//     };

//     try {
//         const response = await messaging.sendEachForMulticast(message);
//         res.status(200).send(`${response.successCount} messages sent.`);
//     } catch (error) {
//         console.error("Error sending messages:", error);
//         res.status(500).send("Failed to send messages.");
//     }
// }
