package com.bap.app.dixit.util;

import com.bap.app.dixit.dto.object.PlayerData;
import com.bap.app.dixit.dto.object.RoomData;

public final class CommonUtils {

    public static void updateState(RoomData rd, int state) {
	rd.setState(state);
	for (PlayerData player : rd.getPlayers().values()) {
	    player.setState(state);
	}
    }

    public static void updateRoomState(RoomData rd, int state) {
	rd.setState(state);
    }

    public static void updatePlayerState(RoomData rd, int playerId, int state) {
	PlayerData player = rd.getPlayers().get(playerId);
	player.setState(state);
    }
}
