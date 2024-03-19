import random


class GameFinished(Exception):
  pass

def lrc_roll():
  return random.randint(0,2)

def finish_condition(pool):
  alive = 0
  for p in range(len(pool)):
    if pool[p] > 0:
      alive = alive + 1
  if alive == 1:
    raise GameFinished()  
  if alive == 0:
    raise Exception("OMG WTF ZERO PLAYAS?")
  return True

def winner(pool):
  for p in range(len(pool)):
    if pool[p] > 0:
      return p

def run_lrc_game(players, initial_money, available_dies=3):
  pool = [initial_money for i in range(players)] 
  #print "INITIAL POOL", pool
  iterations = player_index = center = 0
  try:
    while finish_condition(pool):   
      #print iterations, pool

      if pool[player_index] <= 0:
        #print "PLAYER OUT", player_index
        if player_index >= players - 1:
          player_index = 0      
        else: 
          player_index += 1

        continue
      else:
        #print "PLAYER ROLLING", player_index
        pass

      if pool[player_index] > available_dies:
        dies_to_roll = available_dies
      else:
        dies_to_roll = pool[player_index]
   
      for i in range(dies_to_roll):
        roll = lrc_roll()
        #print "PLAYER", player_index, "ROLLED", roll
        pool[player_index] -= 1
         
        if roll == 0:  # LEFT
          pool[player_index - 1] += 1
        if roll == 1:  # RIGHT
          if player_index == players - 1:
            pool[0] += 1
          else:
            pool[player_index + 1] += 1
        if roll == 2:  # CENTER
          center += 1

      if player_index >= players - 1:
        player_index = 0      
      else: 
        player_index += 1
      finish_condition(pool)
      iterations += 1
  except GameFinished:
    #print "GAME FINISHED"
    return (pool, center)

def winner(pool):
  for i in range(len(pool)):
    if pool[i] > 0:
      return i

players = 5
wins = [0 for i in range(players)]

for i in range(100000):
  if i % 1000 == 0:
    print "runs", i
  finish_pool, center = run_lrc_game(players, 3)
  wins[winner(finish_pool)] += 1

print wins
  
#print "FINISHED", run_lrc_game(5, 3)