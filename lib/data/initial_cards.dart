import 'package:uuid/uuid.dart';

import '../models/card_model.dart';

const _uuid = Uuid();

List<ConversationCard> getInitialCards() {
  return [
    // GREEN CARDS - Perguntas/Iniciadoras de conversa
    ConversationCard(
      id: _uuid.v4(),
      phrase: "How's it going?",
      translation: "Como estão as coisas?",
      category: CardCategory.green,
    ),
    ConversationCard(
      id: _uuid.v4(),
      phrase: "What's up?",
      translation: "E aí, tudo bem?",
      category: CardCategory.green,
    ),
    ConversationCard(
      id: _uuid.v4(),
      phrase: "How are you doing?",
      translation: "Como você está?",
      category: CardCategory.green,
    ),
    ConversationCard(
      id: _uuid.v4(),
      phrase: "Nice weather today, huh?",
      translation: "Climinha bom hoje, né?",
      category: CardCategory.green,
    ),
    ConversationCard(
      id: _uuid.v4(),
      phrase: "Any plans for the weekend?",
      translation: "Tem planos para o fim de semana?",
      category: CardCategory.green,
    ),
    ConversationCard(
      id: _uuid.v4(),
      phrase: "Did you do anything fun yesterday?",
      translation: "Fez algo divertido ontem?",
      category: CardCategory.green,
    ),
    ConversationCard(
      id: _uuid.v4(),
      phrase: "How's work going?",
      translation: "Como está indo o trabalho?",
      category: CardCategory.green,
    ),
    ConversationCard(
      id: _uuid.v4(),
      phrase: "Busy day today?",
      translation: "Dia corrido hoje?",
      category: CardCategory.green,
    ),
    ConversationCard(
      id: _uuid.v4(),
      phrase: "Got any plans tonight?",
      translation: "Tem planos pra hoje à noite?",
      category: CardCategory.green,
    ),
    ConversationCard(
      id: _uuid.v4(),
      phrase: "Did you have lunch yet?",
      translation: "Você já almoçou?",
      category: CardCategory.green,
    ),

    // BLUE CARDS - Respostas/Reações
    ConversationCard(
      id: _uuid.v4(),
      phrase: "Not much, just chilling. You?",
      translation: "Nada demais, só de boa. E você?",
      category: CardCategory.blue,
    ),
    ConversationCard(
      id: _uuid.v4(),
      phrase: "Pretty good, thanks! How about you?",
      translation: "Tô bem, valeu! E você?",
      category: CardCategory.blue,
    ),
    ConversationCard(
      id: _uuid.v4(),
      phrase: "Same old, same old.",
      translation: "A mesma coisa de sempre.",
      category: CardCategory.blue,
    ),
    ConversationCard(
      id: _uuid.v4(),
      phrase: "Can't complain!",
      translation: "Não posso reclamar!",
      category: CardCategory.blue,
    ),
    ConversationCard(
      id: _uuid.v4(),
      phrase: "Oh yeah? How's that going?",
      translation: "Ah é? E como tá indo?",
      category: CardCategory.blue,
    ),
    ConversationCard(
      id: _uuid.v4(),
      phrase: "No way! That's awesome!",
      translation: "Sério? Que demais!",
      category: CardCategory.blue,
    ),
    ConversationCard(
      id: _uuid.v4(),
      phrase: "For real?",
      translation: "Sério mesmo?",
      category: CardCategory.blue,
    ),
    ConversationCard(
      id: _uuid.v4(),
      phrase: "I hear you.",
      translation: "Eu te entendo.",
      category: CardCategory.blue,
    ),
    ConversationCard(
      id: _uuid.v4(),
      phrase: "Yeah, I know what you mean.",
      translation: "Sim, sei bem o que você quer dizer.",
      category: CardCategory.blue,
    ),
    ConversationCard(
      id: _uuid.v4(),
      phrase: "Nothing much, just taking it easy.",
      translation: "Nada demais, só relaxando.",
      category: CardCategory.blue,
    ),
    ConversationCard(
      id: _uuid.v4(),
      phrase: "Not really, just the usual stuff.",
      translation: "Não muito, só o de sempre.",
      category: CardCategory.blue,
    ),
    ConversationCard(
      id: _uuid.v4(),
      phrase: "Probably just gonna relax.",
      translation: "Acho que só vou relaxar.",
      category: CardCategory.blue,
    ),
    ConversationCard(
      id: _uuid.v4(),
      phrase: "I wish! Super busy.",
      translation: "Queria! Tô super ocupado.",
      category: CardCategory.blue,
    ),

    // ORANGE CARDS - Despedidas
    ConversationCard(
      id: _uuid.v4(),
      phrase: "Well, I gotta run. See you later!",
      translation: "Bom, preciso ir. Até mais!",
      category: CardCategory.orange,
    ),
    ConversationCard(
      id: _uuid.v4(),
      phrase: "Alright, take it easy!",
      translation: "Beleza, se cuida!",
      category: CardCategory.orange,
    ),
    ConversationCard(
      id: _uuid.v4(),
      phrase: "Nice talking to you!",
      translation: "Foi bom conversar com você!",
      category: CardCategory.orange,
    ),
    ConversationCard(
      id: _uuid.v4(),
      phrase: "Catch you later!",
      translation: "Falo com você depois!",
      category: CardCategory.orange,
    ),
    ConversationCard(
      id: _uuid.v4(),
      phrase: "Have a good one!",
      translation: "Tenha um bom dia!",
      category: CardCategory.orange,
    ),
  ];
}
