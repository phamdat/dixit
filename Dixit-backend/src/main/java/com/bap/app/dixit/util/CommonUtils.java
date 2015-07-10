package com.bap.app.dixit.util;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.Predicate;

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

    public static void updatePlayerState(RoomData rd, final int playerId, int state) {
	PlayerData player = (PlayerData) CollectionUtils.find(rd.getPlayers().keySet(), new Predicate() {
	    @Override
	    public boolean evaluate(Object arg) {
		return arg.equals(playerId);
	    }
	});
	player.setState(state);
    }
}
