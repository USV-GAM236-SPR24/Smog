extends Node


#region Wilton's Office
var office1_article := Discoverable.new(
	"", "" # Office One: Article
)
var office1_book := Discoverable.new(
	"Dante's Inferno",
	"Turn back and seek the safety of the shore; tempt not the deep, lest, losing unawares me and yourselves, you come to port no more."
)
var office1_letter := Discoverable.new(
	"Letter to Wilton from Cavendish",
	"" # NOTE: https://docs.google.com/document/d/1oVwX6PdUqShLCurGnM892XkfxB5Ukr1lhY9TuSJvXR4/edit
)
#endregion

#region Mailroom
var mailroom_letter := Discoverable.new(
	"Letter to Wilton from Cavendish",
	""
)
var mailroom_photograph := Discoverable.new(
	"Photograph",
	"This photograph depicts Wilton and Cavendish shaking hands and smiling at the camera. There is writing on the back that reads “To our new business venture as partners",
	Discoverable.IMAGE
)
var mailroom_trash_letters := Discoverable.new(
	"Piles of Unopened Letters in the Trash",
	"Piles and piles of unopened letters from Scotland Yard and local journalists addressed to Mr. Reginald Wilton– all in the trash.",
	Discoverable.IMAGE
)
var mailroom_mail_bin := Discoverable.new(
	"Cavendish’s Mail Bin",
	"This mail bin belonging to A. Cavendish seems to be overflowing.",
	Discoverable.IMAGE
)
#endregion

#region Messhall
var messhall_recipe := Discoverable.new(
	"Bread Recipe",
	"- 5 cups Flour\n- 2 cups Chalk\n- 1 cup Plaster of Paris\n- 1 Tsp. Salt\n- 1 Tbl. Lard\n- 3 Tbl. Dry Yeast"
)
var messhall_note := Discoverable.new(
	"Passed Note",
	"" # NOTE: https://docs.google.com/document/u/2/d/1cc30M_M1RW-rTlwy4pf2ku1eHg5Gfmg6DVFDeYGhgyM/edit
)
var messhall_schedule := Discoverable.new(
	"Billy's Work Schedule, Age 7",
	"" # NOTE: https://docs.google.com/document/d/1_FQktL5UonaaLt3OdZbYq0zOtkmjFgoQMXuNaZiBOPc/edit?usp=sharing
)
#endregion

#region Factory Floor 1
var factory_floor1_badge := Discoverable.new(
	"Police Badge",
	"",
	Discoverable.DIALOGUE
)
var factory_floor1_article := Discoverable.new(
	"London is Sick -- is Industry to Blame?",
	"" # NOTE: https://docs.google.com/document/d/1OZqseCzXkRAs8--ErRQQXj7vYET45-JAxLvhkZblGsI/edit?usp=sharing
)
var factory_floor1_letter := Discoverable.new(
	"Letter from Cavendish to Wilton",
	"" # NOTE: https://docs.google.com/document/d/111-8pBKmY-oeWuUZpMvfeDMN2GTu_-xFJvSzU3_Vlko/edit?usp=drive_link
)
#endregion

#region Factory Floor 2
var factory_floor2_letter := Discoverable.new(
	"Letter from journalist to Wilton",
	"" # NOTE: https://docs.google.com/document/u/2/d/1dx5CpJjTmQYUd9yBkYnN2xNFS8z9K_QuNF6ToNm6b4I/edit
)
var factory_floor2_article := Discoverable.new(
	"Mysterious Plague Strikes Local Factory Workers: Dr. Wright Confirms",
	"" # NOTE: https://docs.google.com/document/d/1NVvSYetcwI_TkwxuB_4mQiPr4R6fGEtkIfdPNdsooR4/edit?usp=sharing
)
var factory_floor2_note := Discoverable.new(
	"Ominous Note",
	"I have come to lead you to the other shore; into eternal darkness; into fire and into ice."
)
#endregion

#region Washroom
var washroom_article := Discoverable.new(
	"Cavendish Arrested for Factory Arson and Murder",
	"" # https://docs.google.com/document/u/2/d/1pJbitUodFei10rMPmQpapur0RnnILjjtFsq9Egbl3BA/edit
)
#endregion

#region Storage
var storage_note := Discoverable.new(
	"Ominous Note",
	"I am damned ... there is no escape from the hellfire"
)
#endregion

#region Cavendish's Office
var office2_letter := Discoverable.new(
	"Letter to Cavendish from Wilton",
	"" # NOTE: https://docs.google.com/document/u/0/d/1xqe3L37fBPuWmvBQ8gj3aNqkX2yGT1HDbtKiksxtY2Q/edit
)
var office2_handkerchief := Discoverable.new(
	"Embroidered Handkerchief",
	"The embroidered handkerchief you had custom-made for Cavendish last Christmas. To think that blasted man kept it after all of this time… he didn’t even give you anything worthwhile in return! Nothing but an unremarkable bottle of booze from his family’s dusty old wine cellar…"
)
#endregion

