package com.bap.app.dixit.handler;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bap.app.dixit.dao.CardDAO;
import com.bap.app.dixit.dto.StartGame;
import com.bap.app.dixit.dto.object.RoomData;
import com.bap.app.dixit.util.CommonUtils;
import com.bap.app.dixit.util.Constants;
import com.smartfoxserver.v2.entities.User;

@Service
public class StartGameHandler extends BaseHandler<StartGame> {

    @Autowired
    private CardDAO cardDAO;

    @Override
    public void execute(User sender, StartGame t, RoomData rd) throws Exception {
	List<User> players = sender.getLastJoinedRoom().getUserList();

	rd.setHostId(sender.getId());

	for (User player : players) {
	    send(StartGame.createResponse(rd.getHostId()), player);
	}
	CommonUtils.updateState(rd, Constants.GameState.START_GAME);
    }
}
