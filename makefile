LLC      := llc
AR       := ar
ARFLAGS  := rcs

SRC_DIR  := src
BUILD_DIR:= build
TARGET   := libelx.a

SRC := $(wildcard $(SRC_DIR)/*.ll)
OBJ := $(patsubst $(SRC_DIR)/%.ll,$(BUILD_DIR)/%.o,$(SRC))

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(OBJ)
	$(AR) $(ARFLAGS) $@ $^

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.ll | $(BUILD_DIR)
	$(LLC) -filetype=obj -O2 $< -o $@

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

clean:
	rm -rf $(BUILD_DIR) $(TARGET)
