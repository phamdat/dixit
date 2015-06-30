package com.bap.app.dixit.handler;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang3.RandomUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bap.app.dixit.Constants;
import com.bap.app.dixit.dao.CardDAO;
import com.bap.app.dixit.dto.object.Card;
import com.bap.app.dixit.dto.start.StartResponse;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;

@Service
public class Start extends BaseClientRequestHandler {

	@Autowired
	private CardDAO cardDAO;

	@Override
	public void handleClientRequest(User sender, ISFSObject params) {

		List<User> users = sender.getCurrentMMORoom().getUserList();
		List<Card> cards = cardDAO.findAll();

		for (User user : users) {
			StartResponse response = new StartResponse(sender.getId(), getRandomCards(cards));
			new StartResponse(hostId, cards)
			send(Constants.RequestHandler.START, params, user);
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
