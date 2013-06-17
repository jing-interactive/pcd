import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;

void anim_setup()
{ 
  Ani.init(this);

  float time = 1;
  Easing mode = Ani.CIRC_IN_OUT;

  intro_left_seq = new AniSequence(this);
  intro_left_seq.beginSequence();
  {
    intro_left_seq.add(Ani.to(this, time, "lx_0", left_fly_intros[0].width, mode));
    intro_left_seq.add(Ani.to(this, time, "lx_1", left_fly_intros[1].width, mode));
    intro_left_seq.add(Ani.to(this, time, "lx_2", left_fly_intros[0].width, mode));
    intro_left_seq.add(Ani.to(this, time, "lx_3", left_fly_intros[1].width, mode));  
    intro_left_seq.add(Ani.to(this, time, "lx_4", left_fly_intros[0].width, mode));
  } 
  intro_left_seq.endSequence();  

  intro_right_seq = new AniSequence(this);
  intro_right_seq.endSequence();
  {
    intro_right_seq.add(Ani.to(this, time, "rx_0", right_fly_intros[0].width, mode));
    intro_right_seq.add(Ani.to(this, time, "rx_1", right_fly_intros[1].width, mode));
    intro_right_seq.add(Ani.to(this, time, "rx_2", right_fly_intros[0].width, mode));
    intro_right_seq.add(Ani.to(this, time, "rx_3", right_fly_intros[1].width, mode));
    intro_right_seq.add(Ani.to(this, time, "rx_4", right_fly_intros[0].width, mode));
  }
  intro_right_seq.endSequence();  

mode = Ani.BOUNCE_OUT;
  intro_team_seq = new AniSequence(this);
  intro_team_seq.beginSequence();
  intro_team_seq.beginStep();
  intro_team_seq.add(Ani.to(this, 1.5, "team_x", left_big_team.width, mode));
  intro_team_seq.add(Ani.to(this, 1.5, "team_y", right_big_team.width, mode));
  intro_team_seq.endStep();
  intro_team_seq.endSequence();

  countdown_seq = new AniSequence(this);
  countdown_seq.beginSequence();
  countdown_seq.add(Ani.to(this, 0.2, "count_left", left_fly_count.width));
  countdown_seq.add(Ani.to(this, 0.2, "count_right", right_fly_count.width));  
  countdown_seq.endSequence();
}

