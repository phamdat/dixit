package com.bap.app.dixit.handler;

import java.util.ArrayList;
import java.util.List;
import java.util.Map.Entry;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bap.app.dixit.dao.CardDAO;
import com.bap.app.dixit.dto.GuestGuessCard;
import com.bap.app.dixit.dto.object.PlayerData;
import com.bap.app.dixit.dto.object.RoomData;
import com.bap.app.dixit.util.CommonUtils;
import com.bap.app.dixit.util.Constants;
import com.google.common.base.Predicate;
import com.google.common.collect.Iterables;
import com.smartfoxserver.v2.entities.User;

@Service
public class GuestGuessCardHandler extends BaseHandler<GuestGuessCard> {

    @Autowired
    private CardDAO cardDAO;

    @Override
    public void execute(User sender, GuestGuessCard t, RoomData rd) throws Exception {
	List<User> players = sender.getLastJoinedRoom().getUserList();

	rd.getPlayerGuessedCard().put(sender.getId(), t.getCardId());

	for (User player : players) {
	    send(GuestGuessCard.createResponse(sender.getId()), player);
	}

	CommonUtils.updatePlayerState(rd, sender.getId(), Constants.GameState.GUEST_GUESS_CARD);

	// check if all of guests guessed already
	if (checkAlready(rd)) {
	    boolean allGuessRight = true;
	    List<Integer> addedScorePlayers = new ArrayList<Integer>();
	    for (Entry<Integer, String> ugc : rd.getPlayerGuessedCard().entrySet()) {
		String cardId = ugc.getValue();
		Integer guesserId = ugc.getKey();
		Integer selectorId = rd.getSelectedCards().get(cardId);
		if (selectorId == rd.getHostId()) {
		    addedScorePlayers.add(selectorId);
		} else {
		    rd.getPlayers().get(selectorId).addScore(1);
		    allGuessRight = false;
		}
	    }

	    if (!allGuessRight) {
		for (Integer id : addedScorePlayers) {
		    rd.getPlayers().get(id).addScore(3);
		}
		if (addedScorePlayers.size() > 0) {
		    rd.getPlayers().get(rd.getHostId()).addScore(3);
		}
	    } else {
		for (Integer id : addedScorePlayers) {
		    rd.getPlayers().get(id).addScore(2);
		}
	    }
	}
    }

    private boolean checkAlready(RoomData rd) {
	return !Iterables.any(rd.getPlayers().values(), new Predicate<PlayerData>() {
	    @Override
	    public boolean apply(PlayerData arg0) {
		return arg0.getState() != Constants.GameState.GUEST_GUESS_CARD && arg0.getState() != Constants.GameState.HOST_SELECT_CARD;
	    }
	});
    }
}
