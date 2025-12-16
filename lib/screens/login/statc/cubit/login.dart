abstract class loginstate{}

class OnInitialLoginStats extends loginstate{}

class OnStartLoginStats extends loginstate{}

class OnLoadedloginstats extends loginstate{
  final String taken;
  OnLoadedloginstats(this.taken);
}
class OnErrorloginstats extends loginstate{
  final String errorMessege;
  OnErrorloginstats(this.errorMessege);
}