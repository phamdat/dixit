package com.bap.app.dixit.dto;

import com.bap.app.dixit.annotation.RequestHandler;
import com.bap.app.dixit.util.Constants;

@RequestHandler(Constants.RequestHandler.HOST_SELECT_CARD)
public class HostSelectCard extends BaseDTO {

    private String cardId;

    public static HostSelectCard createResponse() {
	HostSelectCard c = new HostSelectCard();
	return c;
    }

    public String getCardId() {
	return cardId;
    }

    public void setCardId(String cardId) {
	this.cardId = cardId;
    }
}
