const url = "http://192.168.250.86:3000/";
// user
const regisUser = "${url}user/SignUp";
const SignIn = "${url}user/SignIn";
const Logout = "${url}user/Logout";
const getInforUserLogin = "${url}user/getInforuserLogin";
const getInforUser = "${url}user/getInforUser";
const addFirendReq = "${url}user/addFriendReq";
const getListReqAddFriend = "${url}user/getListReqAddFriend";
const getListFriendWhereIdUser = "${url}user/getListFriendWhereIdUser";
const acceptFriendReq = "${url}user/acceptFriendReq";
const getAllUser = "${url}user/getAllUser";
// newPost
const addNewPost = "${url}newPost/addNewPost";
const getAllNewPost = "${url}newPost/getAllNewPost";
const getAllNewPostWhereIdUser = "${url}newPost/getPostWhereId";
const getCommentWhereIdPost = "${url}newPost/getCmt";
const getInforPost = "${url}newPost/getInforPost";
const addCmt = "${url}newPost/addComment";
const getNewPostFromMyFriend = "${url}newPost/getNewPostFromMyFriend";
const likeNewPost = "${url}newPost/likeNewPost";
const unLikeNewPost = "${url}newPost/unLikeNewPost";
const getImageUserFromPost = "${url}newPost/getImageFromPost";
// chat
const sendMessage = "${url}chat/sendMessage";
const getMessage = "${url}chat/getMessage";
const getMyConversation = "${url}chat/getMyConversation";
const updateStatusConversation = "${url}chat/updateStatusReceiver";
