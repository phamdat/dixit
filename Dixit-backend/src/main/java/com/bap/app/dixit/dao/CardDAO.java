package com.bap.app.dixit.dao;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.Predicate;
import org.springframework.stereotype.Repository;

import com.bap.app.dixit.dto.object.Card;
import com.bap.app.dixit.util.JsonUtils;

@Repository
public class CardDAO {

    private final List<Card> CARDS;

    public CardDAO() throws IOException {
	InputStream stream = this.getClass().getClassLoader().getResourceAsStream("cards.json");
	CARDS = JsonUtils.toList(stream, Card.class);
	stream.close();
    }

    public List<Card> findAll() {
	return new ArrayList<Card>(CARDS);
    }

    @SuppressWarnings("unchecked")
    public List<Card> findByIds(final Collection<String> ids) {
	return (List<Card>) CollectionUtils.select(new ArrayList<Card>(CARDS), new Predicate() {
	    @Override
	    public boolean evaluate(Object arg) {
		return ids.contains(((Card) arg).getId());
	    }
	});
    }
}
