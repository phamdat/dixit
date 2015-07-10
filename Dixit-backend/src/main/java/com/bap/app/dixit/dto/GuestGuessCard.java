package com.bap.app.dixit.dto;

import com.bap.app.dixit.annotation.RequestHandler;
import com.bap.app.dixit.util.Constants;

@RequestHandler(Constants.RequestHandler.GUEST_SELECT_CARD)
public class GuestGuessCard extends BaseRequest {

    private String cardId;

    public static GuestGuessCard create() {
	GuestGuessCard c = new GuestGuessCard();
	return c;
    }

    public String getCardId() {
	return cardId;
    }

    public void setCardId(String cardId) {
	this.cardId = cardId;
    }

}
