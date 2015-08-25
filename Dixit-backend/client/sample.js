// Create configuration object
var config = {};
config.host = "127.0.0.1";
config.port = 9696;
config.useSSL = false;
config.zone = "test";
config.debug = false;

var cards;
var selectedCards;

// Create SmartFox client instance
sfs = new SmartFox(config);

sfs.addEventListener(SFS2X.SFSEvent.CONNECTION, onConnection, this);
sfs.connect();

function onConnection(evtParams) {
    if (evtParams.success) {
        console.log("Connection established");
    } else {
        console.log("Connection failed");
    }
}

//****************************************************************************************************
function login() {
    sfs.addEventListener(SFS2X.SFSEvent.LOGIN, onLogin, this);
    sfs.addEventListener(SFS2X.SFSEvent.LOGIN_ERROR, onLoginError, this);
    sfs.addEventListener(SFS2X.SFSEvent.EXTENSION_RESPONSE, onExtensionResponse, this);

    // Login
    sfs.send(new SFS2X.Requests.System.LoginRequest(document.getElementById("name").value));
}

function onLogin(evtParams) {
    console.log("Login successful!");
    joinRoom();
}

function onLoginError(evtParams) {
    console.log("Login failure: " + evtParams.errorMessage);
}

//****************************************************************************************************
function createRoom() {
    sfs.addEventListener(SFS2X.SFSEvent.ROOM_ADD, onRoomCreated, this);
    sfs.addEventListener(SFS2X.SFSEvent.ROOM_CREATION_ERROR, onRoomCreationError, this);

    // Create a new chat Room
    var settings = new SFS2X.Requests.RoomSettings("kaka1");
    settings.maxUsers = 10;
    settings.groupId = "default";

    sfs.send(new SFS2X.Requests.System.CreateRoomRequest(settings));
}

function onRoomCreated(evtParams) {
    console.log("Room created: " + evtParams.room);
    joinRoom();
}

function onRoomCreationError(evtParams) {
    console.log("Room creation failed: " + evtParams.errorMessage);
}

//****************************************************************************************************
function joinRoom() {
    sfs.addEventListener(SFS2X.SFSEvent.ROOM_JOIN, onRoomJoined, this);
    sfs.addEventListener(SFS2X.SFSEvent.ROOM_JOIN_ERROR, onRoomJoinError, this);

    // Join a Room called "Lobby"
    sfs.send(new SFS2X.Requests.System.JoinRoomRequest("test"));
}

function onRoomJoined(evtParams) {
    console.log("Room joined successfully: " + evtParams.room);
}

function onRoomJoinError(evtParams) {
    console.log("Room joining failed: " + evtParams.errorMessage);
}

//****************************************************************************************************
function startGame() {
    // Send two integers to the Zone extension and get their sum in return
    var params = {};
    //params.request = "{}";

    sfs.send(new SFS2X.Requests.System.ExtensionRequest("start_game", params));
}

function drawCard() {
    // Send two integers to the Zone extension and get their sum in return
    var params = {};
    //params.request = "{}";

    sfs.send(new SFS2X.Requests.System.ExtensionRequest("draw_card", params));
}

function hostSelectCard() {
    // Send two integers to the Zone extension and get their sum in return
    var params = {
        request: JSON.stringify({
            cardId: cards[0].id
        })
    };
    //params.request = "{}";

    sfs.send(new SFS2X.Requests.System.ExtensionRequest("host_select_card", params));
}

function guestSelectCard() {
    // Send two integers to the Zone extension and get their sum in return
    var params = {
        request: JSON.stringify({
            cardId: cards[0].id
        })
    };
    //params.request = "{}";

    sfs.send(new SFS2X.Requests.System.ExtensionRequest("guest_select_card", params));
}

function guestGuessCard() {
    // Send two integers to the Zone extension and get their sum in return
    var params = {
        request: JSON.stringify({
            cardId: selectedCards[0].id
        })
    };
    //params.request = "{}";

    sfs.send(new SFS2X.Requests.System.ExtensionRequest("guest_guess_card", params));
}

function onExtensionResponse(evtParams) {
    console.log(evtParams);
    if (evtParams.cmd == "draw_card") {
        cards = JSON.parse(evtParams.params.response).cards;
    } else if (evtParams.cmd == "selected_card") {
        selectedCards = JSON.parse(evtParams.params.response).cards;
    }
}