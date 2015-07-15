package com.bap.app.dixit.dto;

import java.util.List;

import com.bap.app.dixit.annotation.RequestHandler;
import com.bap.app.dixit.dto.object.Card;
import com.bap.app.dixit.util.Constants;

@RequestHandler(Constants.RequestHandler.DRAW_CARD)
public class DrawCard extends BaseRequest {

    private List<Card> cards;

    public static DrawCard create(List<Card> cards) {
	DrawCard c = new DrawCard();
	c.setCards(cards);
	return c;
    }

    public List<Card> getCards() {
	return cards;
    }

    public void setCards(List<Card> cards) {
	this.cards = cards;
    }

}
