package com.bap.app.dixit.handler;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bap.app.dixit.dao.CardDAO;
import com.bap.app.dixit.dto.Scoring;
import com.bap.app.dixit.dto.object.PlayerData;
import com.bap.app.dixit.dto.object.RoomData;
import com.bap.app.dixit.util.CommonUtils;
import com.bap.app.dixit.util.Constants;
import com.smartfoxserver.v2.entities.User;

@Service
public class ScoringHandler extends BaseHandler<Scoring> {

    @Autowired
    private CardDAO cardDAO;

    @Override
    public void execute(User sender, Scoring t, RoomData rd) throws Exception {
	List<User> players = sender.getLastJoinedRoom().getUserList();

	Map<Integer, Integer> playerScore = new LinkedHashMap<Integer, Integer>();
	for (Entry<Integer, PlayerData> p : rd.getPlayers().entrySet()) {
	    playerScore.put(p.getKey(), p.getValue().getScore());
	}

	for (User player : players) {
	    send(Scoring.create(rd.getSelectedCards(), rd.getPlayerGuessedCard(), playerScore), player);
	}

	CommonUtils.updatePlayerState(rd, sender.getId(), Constants.GameState.RETURN_SCORE);
    }
}
