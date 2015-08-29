package com.bap.app.dixit.handler;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bap.app.dixit.dao.CardDAO;
import com.bap.app.dixit.dto.SelectedCard;
import com.bap.app.dixit.dto.object.Card;
import com.bap.app.dixit.dto.object.RoomData;
import com.google.common.base.Predicate;
import com.google.common.collect.Iterables;
import com.google.common.collect.Lists;
import com.smartfoxserver.v2.entities.User;

@Service
public class SelectedCardHandler extends BaseHandler<SelectedCard> {

    @Autowired
    private CardDAO cardDAO;

    @Override
    public void execute(User sender, SelectedCard t, final RoomData rd) throws Exception {
	List<User> players = sender.getLastJoinedRoom().getUserList();
	List<Card> cards = cardDAO.findAll();

	Iterable<Card> it = Iterables.filter(cards, new Predicate<Card>() {
	    @Override
	    public boolean apply(Card arg0) {
		return rd.getSelectedCards().containsKey(arg0.getId());
	    }
	});
	cards = Lists.newArrayList(it);

	for (User player : players) {
	    send(SelectedCard.createResponse(cards), player);
	}
    }
}
