package com.bap.app.dixit.handler;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.Predicate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bap.app.dixit.dao.CardDAO;
import com.bap.app.dixit.dto.GuestGuessCard;
import com.bap.app.dixit.dto.GuestGuessedCard;
import com.bap.app.dixit.dto.Scoring;
import com.bap.app.dixit.dto.object.PlayerData;
import com.bap.app.dixit.dto.object.RoomData;
import com.bap.app.dixit.util.CommonUtils;
import com.bap.app.dixit.util.Constants;
import com.smartfoxserver.v2.entities.User;

@Service
public class GuestGuessCardHandler extends BaseHandler<GuestGuessCard> {

    @Autowired
    private CardDAO cardDAO;

    @Override
    public void execute(User sender, GuestGuessCard t, RoomData rd) throws Exception {
	List<User> players = sender.getLastJoinedRoom().getUserList();

	rd.getPlayerGuessedCard().put(sender.getId(), t.getCardId());
	CommonUtils.updatePlayerState(rd, sender.getId(), Constants.GameState.GUEST_GUESS_CARD);

	// notify that a guest guessed card
	for (User player : players) {
	    send(GuestGuessedCard.create(sender.getId()), player);
	}

	// check if all of guests guessed already
	if (!CollectionUtils.exists(rd.getPlayers().values(), new Predicate() {
	    @Override
	    public boolean evaluate(Object arg0) {
		return ((PlayerData) arg0).getState() != Constants.GameState.GUEST_GUESS_CARD && ((PlayerData) arg0).getState() != Constants.GameState.HOST_SELECT_CARD;
	    }
	})) {
	    boolean allGuessRight = true;
	    for (Entry<Integer, String> ugc : rd.getPlayerGuessedCard().entrySet()) {
		String cardId = ugc.getValue();
		Integer guesserId = ugc.getKey();
		Integer selectorId = rd.getSelectedCards().get(cardId);
		if (selectorId == rd.getHostId()) {
		    rd.getPlayers().get(guesserId).addScore(3);
		} else {
		    rd.getPlayers().get(selectorId).addScore(1);
		    allGuessRight = false;
		}
	    }

	    if (!allGuessRight) {
		rd.getPlayers().get(rd.getHostId()).addScore(3);
	    }

	    Map<Integer, Integer> playerScore = new LinkedHashMap<Integer, Integer>();
	    for (Entry<Integer, PlayerData> p : rd.getPlayers().entrySet()) {
		playerScore.put(p.getKey(), p.getValue().getScore());
	    }

	    for (User player : players) {
		send(Scoring.create(rd.getSelectedCards(), rd.getPlayerGuessedCard(), playerScore), player);
	    }
	}
    }
}
