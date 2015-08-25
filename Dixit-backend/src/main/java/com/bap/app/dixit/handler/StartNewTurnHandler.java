package com.bap.app.dixit.handler;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bap.app.dixit.dao.CardDAO;
import com.bap.app.dixit.dto.StartNewTurn;
import com.bap.app.dixit.dto.object.RoomData;
import com.bap.app.dixit.util.CommonUtils;
import com.bap.app.dixit.util.Constants;
import com.smartfoxserver.v2.entities.User;

@Service
public class StartNewTurnHandler extends BaseHandler<StartNewTurn> {

    @Autowired
    private CardDAO cardDAO;

    @Override
    public void execute(User sender, StartNewTurn t, RoomData rd) throws Exception {
	List<User> players = sender.getLastJoinedRoom().getUserList();

	for (User user : players) {
	    if (user.getPlayerId() > rd.getHostId()) {
		rd.setHostId(sender.getId());
		break;
	    }
	}

	for (User player : players) {
	    send(StartNewTurn.createResponse(rd.getHostId()), player);
	}
	CommonUtils.updateState(rd, Constants.GameState.START_NEW_TURN);
    }
}
