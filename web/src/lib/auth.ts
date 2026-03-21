import admin from "./firebaseAdmin"

type userVerification = {
    token: string;
}

export const verifyFirebaseUser = async({token }:userVerification): Promise<string> => {
    const decoded = await admin.auth().verifyIdToken(token);
    return decoded.uid;
}