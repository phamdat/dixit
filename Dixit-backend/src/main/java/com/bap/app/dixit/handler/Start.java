package com.bap.app.dixit.handler;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.apache.commons.lang3.RandomUtils;
import org.springframework.beans.factory.annotation.Autowired;

import com.bap.app.dixit.Constants;
import com.bap.app.dixit.annotation.RequestHandler;
import com.bap.app.dixit.dao.CardDAO;
import com.bap.app.dixit.dto.object.Card;
import com.bap.app.dixit.dto.start.StartRequest;
import com.bap.app.dixit.dto.start.StartResponse;
import com.bap.app.dixit.util.JsonUtils;
import com.bap.app.handler.BaseHandler;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.variables.SFSUserVariable;
import com.smartfoxserver.v2.entities.variables.UserVariable;

@RequestHandler(Constants.RequestHandler.START)
public class Start extends BaseHandler<StartRequest, StartResponse> {

    @Autowired
    private CardDAO cardDAO;

    @Override
    public void execute(User sender, StartRequest t) throws Exception {
	List<User> users = sender.getLastJoinedRoom().getUserList();
	List<Card> cards = cardDAO.findAll();

	for (User user : users) {
	    List<Card> uCards = getRandomCards(cards);
	    UserVariable uCardsVariable = new SFSUserVariable("cards", JsonUtils.toJson(uCards));
	    getApi().setUserVariables(user, Arrays.asList(uCardsVariable));
	    send(new StartResponse(sender.getId(), uCards), user);
	}
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
