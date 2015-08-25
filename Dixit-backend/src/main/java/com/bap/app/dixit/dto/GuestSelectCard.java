package com.bap.app.dixit.dto;

import com.bap.app.dixit.annotation.RequestHandler;
import com.bap.app.dixit.util.Constants;

@RequestHandler(Constants.RequestHandler.GUEST_SELECT_CARD)
public class GuestSelectCard extends BaseDTO {

    private int playerId;
    private String cardId;

    public static GuestSelectCard createResponse(int playerId) {
	GuestSelectCard c = new GuestSelectCard();
	c.setPlayerId(playerId);
	return c;
    }

    public int getPlayerId() {
	return playerId;
    }

    public void setPlayerId(int playerId) {
	this.playerId = playerId;
    }

    public String getCardId() {
	return cardId;
    }

    public void setCardId(String cardId) {
	this.cardId = cardId;
    }

}
