package com.bap.app.dixit.handler;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang3.RandomUtils;
import org.springframework.beans.factory.annotation.Autowired;

import com.bap.app.dixit.dao.CardDAO;
import com.bap.app.dixit.dto.DrawCard;
import com.bap.app.dixit.dto.HostSelectCard;
import com.bap.app.dixit.dto.StartGame;
import com.bap.app.dixit.dto.object.Card;
import com.bap.app.dixit.dto.object.RoomData;
import com.bap.app.dixit.util.CommonUtils;
import com.bap.app.dixit.util.Constants;
import com.smartfoxserver.v2.entities.User;

public class StartGameHandler extends BaseHandler<StartGame> {

    @Autowired
    private CardDAO cardDAO;

    @Override
    public void execute(User sender, StartGame t, RoomData rd) throws Exception {
	List<User> players = sender.getLastJoinedRoom().getPlayersList();
	List<Card> cards = cardDAO.findAll();

	// draw cards
	for (User player : players) {
	    List<Card> uCards = getRandomCards(cards);
	    rd.getPlayers().get(player.getId()).setCurCards(uCards);
	    send(DrawCard.create(uCards), player);
	}
	CommonUtils.updateState(rd, Constants.GameState.DRAW_CARD);

	// TODO: should delay here

	// notify that host can select card now
	for (User player : players) {
	    rd.setHostId(sender.getId());
	    send(HostSelectCard.create(sender.getId()), player);
	}
	CommonUtils.updateRoomState(rd, Constants.GameState.HOST_SELECT_CARD);
    }

    private List<Card> getRandomCards(List<Card> cards) {
	List<Card> res = new ArrayList<Card>();
	for (int i = 0; i < Constants.Game.NUM_OF_CARD; i++) {
	    int rindex = RandomUtils.nextInt(0, cards.size() - 1);
	    res.add(cards.get(rindex));
	    cards.remove(rindex);
	}
	return res;
    }

}
