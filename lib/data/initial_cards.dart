import 'package:uuid/uuid.dart';
import '../models/card_model.dart';

const _uuid = Uuid();

List<ConversationCard> getInitialCards() {
  return [
    // GREEN CARDS - Perguntas/Iniciadoras de conversa
    ConversationCard(
      id: _uuid.v4(),
      phrase: "How's it going?",
      category: CardCategory.green,
    ),
    ConversationCard(
      id: _uuid.v4(),
      phrase: "What's up?",
      category: CardCategory.green,
    ),
    ConversationCard(
      id: _uuid.v4(),
      phrase: "How are you doing?",
      category: CardCategory.green,
    ),
    ConversationCard(
      id: _uuid.v4(),
      phrase: "Nice weather today, huh?",
      category: CardCategory.green,
    ),
    ConversationCard(
      id: _uuid.v4(),
      phrase: "Any plans for the weekend?",
      category: CardCategory.green,
    ),
    ConversationCard(
      id: _uuid.v4(),
      phrase: "Did you do anything fun yesterday?",
      category: CardCategory.green,
    ),
    ConversationCard(
      id: _uuid.v4(),
      phrase: "How's work going?",
      category: CardCategory.green,
    ),
    ConversationCard(
      id: _uuid.v4(),
      phrase: "Busy day today?",
      category: CardCategory.green,
    ),
    ConversationCard(
      id: _uuid.v4(),
      phrase: "Got any plans tonight?",
      category: CardCategory.green,
    ),
    ConversationCard(
      id: _uuid.v4(),
      phrase: "Did you have lunch yet?",
      category: CardCategory.green,
    ),

    // BLUE CARDS - Respostas/Reações
    ConversationCard(
      id: _uuid.v4(),
      phrase: "Not much, just chilling. You?",
      category: CardCategory.blue,
    ),
    ConversationCard(
      id: _uuid.v4(),
      phrase: "Pretty good, thanks! How about you?",
      category: CardCategory.blue,
    ),
    ConversationCard(
      id: _uuid.v4(),
      phrase: "Same old, same old.",
      category: CardCategory.blue,
    ),
    ConversationCard(
      id: _uuid.v4(),
      phrase: "Can't complain!",
      category: CardCategory.blue,
    ),
    ConversationCard(
      id: _uuid.v4(),
      phrase: "Oh yeah? How's that going?",
      category: CardCategory.blue,
    ),
    ConversationCard(
      id: _uuid.v4(),
      phrase: "No way! That's awesome!",
      category: CardCategory.blue,
    ),
    ConversationCard(
      id: _uuid.v4(),
      phrase: "For real?",
      category: CardCategory.blue,
    ),
    ConversationCard(
      id: _uuid.v4(),
      phrase: "I hear you.",
      category: CardCategory.blue,
    ),
    ConversationCard(
      id: _uuid.v4(),
      phrase: "Yeah, I know what you mean.",
      category: CardCategory.blue,
    ),
    ConversationCard(
      id: _uuid.v4(),
      phrase: "Nothing much, just taking it easy.",
      category: CardCategory.blue,
    ),
    ConversationCard(
      id: _uuid.v4(),
      phrase: "Not really, just the usual stuff.",
      category: CardCategory.blue,
    ),
    ConversationCard(
      id: _uuid.v4(),
      phrase: "Probably just gonna relax.",
      category: CardCategory.blue,
    ),
    ConversationCard(
      id: _uuid.v4(),
      phrase: "I wish! Super busy.",
      category: CardCategory.blue,
    ),

    // ORANGE CARDS - Despedidas
    ConversationCard(
      id: _uuid.v4(),
      phrase: "Well, I gotta run. See you later!",
      category: CardCategory.orange,
    ),
    ConversationCard(
      id: _uuid.v4(),
      phrase: "Alright, take it easy!",
      category: CardCategory.orange,
    ),
    ConversationCard(
      id: _uuid.v4(),
      phrase: "Nice talking to you!",
      category: CardCategory.orange,
    ),
    ConversationCard(
      id: _uuid.v4(),
      phrase: "Catch you later!",
      category: CardCategory.orange,
    ),
    ConversationCard(
      id: _uuid.v4(),
      phrase: "Have a good one!",
      category: CardCategory.orange,
    ),
  ];
}
