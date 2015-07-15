package com.bap.app.dixit.handler;

import java.util.List;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.Predicate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bap.app.dixit.dao.CardDAO;
import com.bap.app.dixit.dto.GuestGuessCard;
import com.bap.app.dixit.dto.GuestSelectCard;
import com.bap.app.dixit.dto.GuestSelectedCard;
import com.bap.app.dixit.dto.SelectedCard;
import com.bap.app.dixit.dto.object.PlayerData;
import com.bap.app.dixit.dto.object.RoomData;
import com.bap.app.dixit.util.CommonUtils;
import com.bap.app.dixit.util.Constants;
import com.smartfoxserver.v2.entities.User;

@Service
public class GuestSelectCardHandler extends BaseHandler<GuestSelectCard> {

    @Autowired
    private CardDAO cardDAO;

    @Override
    public void execute(User sender, GuestSelectCard t, RoomData rd) throws Exception {
	List<User> players = sender.getLastJoinedRoom().getUserList();

	rd.getSelectedCards().put(t.getCardId(), sender.getId());
	CommonUtils.updatePlayerState(rd, sender.getId(), Constants.GameState.GUEST_SELECT_CARD);

	// notify that a guest selected card
	for (User player : players) {
	    send(GuestSelectedCard.create(sender.getId()), player);
	}

	// check if all of guests selected already
	if (!CollectionUtils.exists(rd.getPlayers().values(), new Predicate() {
	    @Override
	    public boolean evaluate(Object arg0) {
		return ((PlayerData) arg0).getState() != Constants.GameState.GUEST_SELECT_CARD && ((PlayerData) arg0).getState() != Constants.GameState.HOST_SELECT_CARD;
	    }
	})) {
	    // if done, notify selected cards
	    for (User player : players) {
		send(SelectedCard.create(cardDAO.findByIds(rd.getSelectedCards().keySet())), player);
	    }

	    // TODO: should delay here

	    // notify that guest can guess card now
	    for (User player : players) {
		send(GuestGuessCard.create(), player);
	    }
	}
    }
}
